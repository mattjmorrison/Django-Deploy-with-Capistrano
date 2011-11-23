set :application, "sample"
set :repository,  "git://github.com/mattjmorrison/Django-Deploy-with-Capistrano.git"
set :user, "root"
set :deploy_to, "/#{user}/#{application}"
set :scm, :git

role :web, "root@50.57.191.43"
role :app, "root@50.57.191.43"
role :db,  "root@50.57.191.43", :primary => true

namespace :deploy do
  task :finalize_update, :except => { :no_release => true } do
    run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)
  end

  task :post_update_code do
    mkvirtualenv
    installdeps
    migrations
  end

  task :mkvirtualenv do
    run "mkdir -p virtualenvs"
    run "virtualenv virtualenvs/#{release_name} --no-site-packages"  
  end

  task :installdeps do
    run "./virtualenvs/#{release_name}/bin/pip install -r #{latest_release}/requirements.txt"  
  end

  task :migrations do
    on_rollback do
      rollback_migrations    
    end

    run "./virtualenvs/#{release_name}/bin/python #{latest_release}/manage.py syncdb --noinput"
    run "./virtualenvs/#{release_name}/bin/python #{latest_release}/manage.py migrate --noinput --ignore-ghost-migrations"  
    run "something that is going to be invalid goes right here!"
  end
  
end

after 'deploy', 'deploy:cleanup'
after 'deploy:update_code', 'deploy:post_update_code'

def get_migrations(release)
  migration_string = capture "find #{release} -name [0-9]*.py -path */migrations/*"  
  migration_string.split("\n").collect {|m| (m["#{release}/"] = '') && m }
end

def rollback_migrations
  if previous_release
    rollback_migrations = get_migrations(latest_release) - get_migrations(previous_release)

    reverse_migrations = rollback_migrations.each_with_object(Hash.new {|h, k| h[k] = []}) do |m, hsh|
      app, _, migration = m.split("/")
      hsh[app] << migration.split("_")[0].to_i - 1
    end

    reverse_migrations.each do |app, migrations|
      migration_number = migrations.min
      migration = migration_number == 0 ? 'zero' : "%04d" % migration_number
      puts "#{app} #{migration}"
      #run "./virtualenvs/#{release_name}/bin/python #{latest_release}/manage.py migrate #{app} #{migration} --noinput --ignore-ghost-migrations"
    end

  end
end


# asdf3f6DqBRt1



#lame stuff below

task :post_deploy do
end
task :post_check do
end
task :post_cleanup do
end
task :post_cold do
end
task :post_finalize_update do
end
task :post_migrate do
end
task :post_migrations do
end
task :post_pending do
end
task :post_pending_diff do
end
task :post_restart do
end
task :post_rollback do
end
task :post_rollback_cleanup do
end
task :post_rollback_code do
end
task :post_rollback_revision do
end
task :post_setup do
end
task :post_start do
end
task :post_stop do
end
task :post_symlink do
end
task :post_update do
end
task :post_upload do
end
task :post_web_disable do
end
task :post_web_enable do
end
task :post_invoke do
end
task :post_shell do
end

# ordered
after 'deploy:finalize_update', :post_finalize_update
#after 'deploy:update_code', :post_update_code
after 'deploy:symlink', :post_symlink
after 'deploy:update', :post_update
after 'deploy:restart', :post_restart
after 'deploy', :post_deploy


# not called
after 'deploy:check', :post_check
after 'deploy:cleanup', :post_cleanup
after 'deploy:cold', :post_cold

after 'deploy:migrate', :post_migrate
after 'deploy:migrations', :post_migrations
after 'deploy:pending', :post_pending
after 'deploy:pending:diff', :post_pending_diff

after 'deploy:rollback', :post_rollback
after 'deploy:rollback:cleanup', :post_rollback_cleanup
after 'deploy:rollback:code', :post_rollback_code
after 'deploy:rollback:revision', :post_rollback_revision
after 'deploy:setup', :post_setup
after 'deploy:start', :post_start
after 'deploy:stop', :post_stop



after 'deploy:upload', :post_upload
after 'deploy:web:disable', :post_web_disable
after 'deploy:web:enable', :post_web_enable
after :invoke, :post_invoke 
after :shell, :post_shell
