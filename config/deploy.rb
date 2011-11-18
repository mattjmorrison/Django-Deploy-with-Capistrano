set :application, "sample"
set :repository,  "git://github.com/mattjmorrison/Django-Deploy-with-Capistrano.git"

set :user, "root"
set :deploy_to, "/#{user}/#{application}"

set :scm, :git
role :web, "root@50.57.187.102"
role :app, "root@50.57.187.102"
role :db,  "root@50.57.187.102", :primary => true

namespace :deploy do
  task :update do
    transaction do
      update_code
      symlink
    end
  end

  task :finalize_update, :except => { :no_release => true } do
    run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)

    # mkdir -p is making sure that the directories are there for some SCM's that don't
    # save empty folders
    run <<-CMD
      rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp/pids &&
      mkdir -p #{latest_release}/public &&
      mkdir -p #{latest_release}/tmp
    CMD

    shared_children.map do |d|
      run "ln -s #{shared_path}/#{d.split('/').last} #{latest_release}/#{d}"
    end

    if fetch(:normalize_asset_timestamps, true)
      stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
      asset_paths = fetch(:public_children, %w(images stylesheets javascripts)).map { |p| "#{latest_release}/public/#{p}" }.join(" ")
    end
  end  
end


task :post_update_code do
  run "mkdir -p virtualenvs"
  run "virtualenv virtualenvs/#{release_name} --no-site-packages"
end

task :post_deploy do
  puts "\n\n\n after_deploy \n\n\n"
end

task :post_check do
  puts "\n\n\n after_check \n\n\n"
end

task :post_cleanup do
  puts "\n\n\n after_cleanup \n\n\n"
end

task :post_cold do
  puts "\n\n\n after_cold \n\n\n"
end

task :post_finalize_update do
  puts "\n\n\n after_finalize_update \n\n\n"
end

task :post_migrate do
  puts "\n\n\n after_migrate \n\n\n"
end

task :post_migrations do
  puts "\n\n\n after_migrations \n\n\n"
end

task :post_pending do
  puts "\n\n\n after_pending \n\n\n"
end

task :post_pending_diff do
  puts "\n\n\n after_pending_diff \n\n\n"
end

task :post_restart do
  puts "\n\n\n after_restart \n\n\n"
end

task :post_rollback do
  puts "\n\n\n after_rollback \n\n\n"
end

task :post_rollback_cleanup do
  puts "\n\n\n after_rollback_cleanup \n\n\n"
end

task :post_rollback_code do
  puts "\n\n\n after_rollback_code \n\n\n"
end

task :post_rollback_revision do
  puts "\n\n\n after_rollback_revision \n\n\n"
end

task :post_setup do
  puts "\n\n\n after_setup \n\n\n"
end

task :post_start do
  puts "\n\n\n after_start \n\n\n"
end

task :post_stop do
  puts "\n\n\n after_stop \n\n\n"
end

task :post_symlink do
  puts "\n\n\n after_symlink \n\n\n"
end

task :post_update do
  puts "\n\n\n after_update \n\n\n"
end

task :post_upload do
  puts "\n\n\n after_upload \n\n\n"
end

task :post_web_disable do
  puts "\n\n\n after_web_disable \n\n\n"
end

task :post_web_enable do
  puts "\n\n\n after_web_enable \n\n\n"
end

task :post_invoke do
  puts "\n\n\n after_invoke \n\n\n"
end

task :post_shell do
  puts "\n\n\n after_shell \n\n\n"
end


# ordered
after 'deploy:finalize_update', :post_finalize_update
after 'deploy:update_code', :post_update_code
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

