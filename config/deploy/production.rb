set :default_env, { PATH: '/opt/rubies/ruby-2.6.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' }
set :passenger_restart_with_touch, true

remote_user = Net::SSH::Config.for('af-transit-app4.admin.umass.edu')[:user] || ENV['USER']
server 'af-transit-app4.admin.umass.edu',
       roles: %w[app web],
       user: remote_user
