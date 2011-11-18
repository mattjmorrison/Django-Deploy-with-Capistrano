set :application, "sample"
set :repository,  "http://github.com:mattjmorrison/Django-Deploy-with-Capistrano.git"
set :scm, :git
role :web, "50.57.187.102"
role :app, "50.57.187.102"
role :db,  "50.57.187.102", :primary => true
