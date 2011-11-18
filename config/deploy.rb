set :application, "sample"
set :repository,  "git://github.com/mattjmorrison/Django-Deploy-with-Capistrano.git"
set :user, "root"
set :deploy_to, "/#{user}/#{application}"
set :scm, :git
role :web, "root@50.57.187.102"
role :app, "root@50.57.187.102"
role :db,  "root@50.57.187.102", :primary => true

namespace :deploy do
  task :finalize_update, :except => { :no_release => true } do
    run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)
  end
end

after 'deploy', 'deploy:cleanup'
after 'deploy:update_code', :post_update_code

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
#  on_rollback do
#  end

  if previous_release
    old_migrations = capture "find #{previous_release} -name [0-9]*.py -path */migrations/*"
    puts "OLD MIGRATIONS: #{old_migrations}"
    new_migrations = capture "find #{latest_release} -name [0-9]*.py -path */migrations/*"    
    puts "NEW MIGRATIONS: #{new_migrations}"

    old_migration_list = []
    old_migrations.split('\n').each do |m|
      m["#{previous_release}"] = ''
      old_migration_list << m
    end

    new_migration_list = []
    new_migrations.split('\n').each do |m|
      m["#{latest_release}"] = ''
      new_migration_list << m      
    end
    
    puts (new_migration_list - old_migration_list)

  end

  run "./virtualenvs/#{release_name}/bin/python #{latest_release}/manage.py syncdb --noinput"
  run "./virtualenvs/#{release_name}/bin/python #{latest_release}/manage.py migrate --noinput --ignore-ghost-migrations"  
end











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
