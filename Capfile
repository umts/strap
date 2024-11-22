# frozen_string_literal: true

%w[setup deploy bundler passenger scm/git].each do |lib|
  require "capistrano/#{lib}"
end
install_plugin Capistrano::SCM::Git
