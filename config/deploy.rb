# config valid for current version and patch releases of Capistrano
lock '~> 3.16'

set :application, 'strap'

set :repo_url, 'https://github.com/umts/strap.git'
set :branch, :master

set :keep_releases, 5

set :deploy_to, "/srv/#{fetch :application}"

set :log_level, :info

before 'git:check', 'git:allow_shared'

namespace :git do
  desc 'Allow use of shared git repository'
  task :allow_shared do
    on release_roles(:all), in: :groups,
                            limit: fetch(:git_max_concurrent_connections),
                            wait: fetch(:git_wait_interval) do
      with fetch(:git_environmental_variables) do
        execute :git, :config, '--global', '--replace-all', 'safe.directory', repo_path, repo_path
      end
    end
  end
end
