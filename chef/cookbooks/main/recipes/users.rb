if node[:users]
    node[:users].each_pair do |username, info|
      group username do
         gid info[:id] 
      end

      user username do 
          comment info[:full_name]
          uid info[:id]
          gid info[:id]
          shell info[:disabled] ? "/sbin/nologin" : "/bin/bash"
          supports :manage_home => true
          home "/home/#{username}"
          notifies :create
      end

      directory "/home/#{username}/.ssh" do
          owner username
          group username
          mode 0700
      end

      file "/home/#{username}/.ssh/authorized_keys" do
          owner username
          group username
          mode 0600
          content info[:key]
      end
    end
end

if node[:groups]
    node[:groups].each_pair do |name, info|
      group name do
          gid info[:gid]
          members info[:members]
      end
    end
end