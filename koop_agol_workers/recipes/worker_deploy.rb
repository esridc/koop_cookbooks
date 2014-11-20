include_recipe 'deploy'

directory node[:koop][:data_dir] do
  mode 0755
  action :create
end

node[:deploy].each do |application, deploy|
  template 'default.json' do
    cookbook 'koop_agol_workers'
    path "#{deploy[:current_path]}/workers/config/default.json"
    source 'default.json.erb'
    owner 'root'
    group 'root'
    mode 0644
  end

  execute 'start workers' do
    command "forever start #{deploy[:current_path]}/workers/request_worker.js"
  end

end
