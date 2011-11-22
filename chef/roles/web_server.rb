name "web_server"
description "Builds a web server for Rails apps"
run_list( "recipe[apache2]" )