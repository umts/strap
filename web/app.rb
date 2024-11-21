# frozen_string_literal: true

require 'sinatra'
require 'omniauth-github'
require 'octokit'
require 'rack/protection'
require 'active_support/core_ext/object/blank'

# Don't worry: these credentials are not sensitive but just use for
# "Strap (development)" with the URL and callback both set to localhost.
GITHUB_KEY = ENV.fetch('GITHUB_KEY', 'b28d0c47b8925e999e49')
GITHUB_SECRET = ENV.fetch('GITHUB_SECRET', '037ac891e2e0b8bc91558d5ff358d2ff4fa1beb7')

SESSION_SECRET = ENV.fetch('SESSION_SECRET')
STRAP_ISSUES_URL = ENV.fetch('STRAP_ISSUES_URL', nil)
STRAP_BEFORE_INSTALL = ENV.fetch('STRAP_BEFORE_INSTALL', nil)
CUSTOM_HOMEBREW_TAP = ENV.fetch('CUSTOM_HOMEBREW_TAP', nil)
CUSTOM_BREW_COMMAND = ENV.fetch('CUSTOM_BREW_COMMAND', nil)
OMNIAUTH_FULL_HOST = ENV.fetch('OMNIAUTH_FULL_HOST', nil)
RACK_ENV = ENV.fetch('RACK_ENV', nil)

# In some configurations, the full host may need to be set to something other
# than the canonical URL.
if OMNIAUTH_FULL_HOST
  OmniAuth.config.full_host = OMNIAUTH_FULL_HOST

  # For some reason this needs to be a no-op when using OMNIAUTH_FULL_HOST
  OmniAuth.config.request_validation_phase = nil
end

set :sessions, secret: SESSION_SECRET

use OmniAuth::Builder do
  options = {
    # access is given for gh cli, packages, git client setup and repo checkouts
    scope: 'user:email, repo, workflow, write:packages, read:packages, read:org, read:discussions',
    allow_signup: false
  }
  options[:provider_ignores_state] = true if RACK_ENV == 'development'
  provider :github, GITHUB_KEY, GITHUB_SECRET, options
end

use Rack::Protection, use: %i[authenticity_token cookie_tossing form_token
                              remote_referrer strict_transport]

get '/auth/github/callback' do
  auth = request.env['omniauth.auth']

  session[:auth] = {
    'info' => auth['info'],
    'credentials' => auth['credentials']
  }

  redirect to '/'
end

get '/' do
  @title = '👢 Strap'

  @strap_before_install = STRAP_BEFORE_INSTALL
  @strap_issues_url = STRAP_ISSUES_URL
  @authorized = session[:auth].present?
  @csrf_token = request.env['rack.session']['csrf']

  erb :root
end

get '/strap.sh' do
  auth = session[:auth]

  script = File.expand_path("#{File.dirname(__FILE__)}/../bin/strap.sh")
  content = File.read(script)

  set_variables = { STRAP_ISSUES_URL: STRAP_ISSUES_URL }
  unset_variables = {}

  unset_variables[:CUSTOM_HOMEBREW_TAP] = CUSTOM_HOMEBREW_TAP if CUSTOM_HOMEBREW_TAP

  unset_variables[:CUSTOM_BREW_COMMAND] = CUSTOM_BREW_COMMAND if CUSTOM_BREW_COMMAND

  if auth
    unset_variables.merge! STRAP_GIT_NAME: auth['info']['name'],
                           STRAP_GIT_EMAIL: auth['info']['email'],
                           STRAP_GITHUB_USER: auth['info']['nickname'],
                           STRAP_GITHUB_TOKEN: auth['credentials']['token']
  end

  env_sub(content, set_variables, set: true)
  env_sub(content, unset_variables, set: false)

  content_type = if params['text']
                   'text/plain'
                 else
                   'application/octet-stream'
                 end

  # Manually set X-Frame-Options because Rack::Protection won't set it on
  # non-HTML files:
  # https://github.com/sinatra/sinatra/blob/v2.0.7/rack-protection/lib/rack/protection/frame_options.rb#L32
  [200, { "X-Frame-Options" => "DENY", "Content-Type" => content_type }, content.lines]
end

private

def env_sub(content, variables, set:)
  variables.each do |key, value|
    next if value.blank?

    regex = if set
              /^#{key}='.*'$/
            else
              /^# #{key}=$/
            end
    escaped_value = value.gsub("'", "\\\\\\\\'")
    content.gsub!(regex, "#{key}='#{escaped_value}'")
  end
end
