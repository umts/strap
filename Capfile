%w[setup deploy bundler passenger pending scm/git].each do |lib|
  require "capistrano/#{lib}"
end
install_plugin Capistrano::SCM::Git
