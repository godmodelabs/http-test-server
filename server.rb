# frozen_string_literal: true

require 'rubygems'
require 'sinatra'

def disabled?(obj)
  return false if obj.nil?
  return true if %w[false no 0].include?(obj.to_s)

  false
end

configure do
  set :start_time, Time.now
end

disable :logging if disabled?(ENV['LOGGING'])

# simply accept calls
get '/?' do
  'GET'
end

post '/?' do
  'POST'
end

put '/?' do
  'PUT'
end

delete '/?' do
  'DELETE'
end

# return version environment variable for testing
get '/version?' do
  env_name = 'VERSION'
  if ENV.key?(env_name)
    "#{env_name} - #{ENV[env_name]}"
  else
    "#{env_name} not set"
  end
end

# return provided content type
get '/contenttype/?' do
  request.env['CONTENT_TYPE']
end

post '/contenttype/?' do
  request.env['CONTENT_TYPE']
end

put '/contenttype/?' do
  request.env['CONTENT_TYPE']
end

delete '/contenttype/?' do
  request.env['CONTENT_TYPE']
end

# return provided body
get '/body/?' do
  request.body
end

post '/body/?' do
  request.body
end

put '/body/?' do
  request.body
end

delete '/body/?' do
  request.body
end

# return provided body
get '/vary/:header_list' do
  header_names = params['header_list'].split(',').map(&:strip)
  key_names = header_names.map { |header| [header, 'HTTP_' + header.upcase.tr('-', '_')] }
  header_strings = []
  key_names.each do |header_array|
    header_strings << if request.env[header_array[1]]
                        format('%<header>s: %<header_value>s', header: header_array[0], header_value: request.env[header_array[1]])
                      else
                        format('%<header>s: %<header_value>s', header: header_array[0], header_value: '<unavailable>')
                      end
  end
  halt 200, { 'Vary' => params['header_list'], 'Cache-Control' => 's-maxage=30' }, "Vary: #{params['header_list']} - Date: #{Time.now.rfc822} - #{header_strings.join(' - ')}"
end

# return requests http status code
get %r{/([0-9]{3})} do
  status_code = params['captures'].first.to_i
  halt status_code, { 'Content-Type' => 'text/plain' }, "returned #{status_code}"
end

# return requests http status code
get %r{/(fail|warn)-after/([0-9]+)} do
  mode = params['captures'].first
  timeout = params['captures'][1].to_i
  fail_time = Time.now - (settings.start_time + timeout)
  status_code = 200
  if fail_time.positive?
    # timeout run out
    status_code = if mode == 'warn'
                    429
                  else
                    500
                  end
  end
  halt status_code, { 'Content-Type' => 'text/plain' }, "returned #{status_code}"
end
