# config valid for current version and patch releases of Capistrano
lock '~> 3.16'

set :application, 'strap'

set :repo_url, 'https://github.com/umts/strap.git'
set :branch, :master

set :keep_releases, 5

set :deploy_to, "/srv/#{fetch :application}"

set :log_level, :info
