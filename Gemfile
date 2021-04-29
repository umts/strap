# frozen_string_literal: true

source "https://rubygems.org"

ruby IO.read(File.expand_path("#{File.dirname(__FILE__)}/.ruby-version")).strip

gem "activesupport"
gem "octokit"
gem "omniauth-github"
gem "sinatra"
gem "unicorn"

group :development do
  gem "capistrano", '~> 3.16'
  gem "capistrano-bundler"
  gem "capistrano-passenger"
  gem "foreman"
  gem "guard"
  gem "guard-process"
  gem "rubocop"
end
