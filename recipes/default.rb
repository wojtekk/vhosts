raise 'No apache configuration found for node.' unless node['apache2']
raise 'No vhosts configured for this node.' unless node['apache2']['vhosts']

include_recipe 'apache2'

node['apache2']['vhosts'].each do |vhost|
  web_app vhost['name'] do
    template 'web_app.ssl.conf.erb'
    server_name vhost['name']
    server_aliases vhost['aliases']
    ssl (vhost.include?('ssl') ? vhost['ssl'] : true)
    domain vhost['domain']
    app_env vhost['environment']
    locations vhost['locations']

    if vhost['path']
      path vhost['path']
    else
      path "/var/www/#{vhost['name']}/current/public"
    end
  end
end
