package "apache2"
package "libapache2-mod-wsgi"

baseline_virtualenv = "/etc/apache2/baseline_virtualenv"
execute "virtualenv #{baseline_virtualenv} --no-site-packages"

service "apache2" do
    service_name "apache2"
    restart_command "/usr/sbin/invoke-rc.d apache2 restart && sleep 1"
    reload_command "/usr/sbin/invoke-rc.d apache2 reload && sleep 1"
    action :enable
end

template "apache2.conf" do
    path "/etc/apache2/apache2.conf"
    source "apache2.conf.erb"
    variables :baseline_virtualenv => baseline_virtualenv
    owner "root"
    group "root"
    mode 0644
    notifies :restart, resources(:service => "apache2")
end

template "site" do
    patch "/etc/apache2/sites-available/site"
    source "site.conf.erb"
    owner "root"
    group "root"
    mode 0644
    notifies :restart, resources(:service => "apache2")
end