# Create Directories
node['icecast2']['app']['createDirs'].each do |dirs|
	directory "#{dirs}" do
		owner "icecast2"
		group "icecast"
		mode "0755"
		action :create
		recursive true
	end
end

# Create Necessary Items
node['icecast2']['app']['createItens'].each do |itens|
	file "#{itens}" do
		action :create_if_missing 
	end
end

# Configure Client
#node[:clients][:client].each do |client|

search(:clients) do |client|

#	Tras o array de valores
	client_name = client["name"]
	port = client["port"]
	loglevel = client["logLevel"]

	num_clients = client["numClients"]

	source_pass = client["sourcePass"]
	admin_pass = client["adminPass"]

	max_listener = client["maxListener"]
	max_listener_duration = client["maxListenerDuration"]
	bitrate = client["bitrate"]
	
	service "icecast2-#{client_name}" do
		supports :status => false, :restart => true, :reload => true
		pattern "icecast2-#{client_name}"
		action [ :enable ]
	end

	file "#{node['icecast2']['app']['authPath']}/#{client_name}" do
		action :create
		owner "icecast2"
		group "root"
		mode "0755"
	end

	directory "#{node['icecast2']['log']['dir']}/#{client_name}" do
		action :create
		recursive true
                owner "icecast2"
                group "icecast"
                mode "0755"
	end

	directory "#{node['icecast2']['app']['icecastDir'}/clients/#{client_name}" do
		action :create
		owner "icecast2"
		group "icecast"
		mode "0755"
	end

	template "/etc/init.d/icecast2-#{client_name}" do
		source "init-icecast2.erb"
		mode   "0775"
		owner  "icecast2"
		group  "root"
		variables(
			:client => "#{client_name}",
			:config_file => "#{node['icecast2']['app']['icecastDir']}/clients/#{client_name}/icecast2.xml"
		 )
	end

	template "#{node['icecast2']['app']['icecastDir']}/clients/#{client_name}/icecast2.xml" do
		source "icecast2.xml.erb"
		mode   "0644"
		owner  "icecast2"
		group  "root"
		variables(
			:client => "#{client_name}",
			:port => "#{port}",
			:num_clients => "#{num_clients}",
			:source_pass => "#{source_pass}",
			:admin_pass => "#{admin_pass}",
			:loglevel => "#{loglevel}"
		 )
#		notifies :restart, resources(:service => "icecast2")
	end

	template "#{node['icecast2']['app']['icecastDir']}/clients/#{client_name}/mountpoint.xml" do
		source "mountpoint.xml.erb"
		mode   "0644"
		owner  "icecast2"
		group  "root"
		variables(
			:client => "#{client_name}",
			:max_listener => "#{max_listener}",
			:max_listener_duration => "#{max_listener_duration}",
			:bitrate => "#{bitrate}"
		 )
#		notifies :restart, resources(:service => "icecast2")
	end

	template "#{node['nginx']['dir']}/conf.d/#{client_name}.radio"do
		source "nginx.conf.erb"
		mode "0644"
		owner "www-data"
		group "www-data"
		variables(
                        :client => "#{client_name}",
                        :port => "#{port}"
		)
	end
	
	# Apenas Inicia
	service "icecast2-#{client_name}" do
		action :start
	end
end


