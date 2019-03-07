set :default_env, { PATH: '/opt/ruby/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' }
remote_user = Net::SSH::Config.for('af-transit-app4.admin.umass.edu')[:user] || ENV['USER']
server 'af-transit-app4.admin.umass.edu',
       roles: %w[app web],
       user: remote_user
