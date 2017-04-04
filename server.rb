require 'rubygems'
require 'sinatra'

# simply accept calls
get '/?' do
  "GET"
end

post '/?' do
  "POST"
end

put '/?' do
  "PUT"
end

delete '/?' do
  "DELETE"
end

# return provided content type
get '/contenttype/?' do
  request.env["CONTENT_TYPE"]
end

post '/contenttype/?' do
  request.env["CONTENT_TYPE"]
end

put '/contenttype/?' do
  request.env["CONTENT_TYPE"]
end

delete '/contenttype/?' do
  request.env["CONTENT_TYPE"]
end

# return provided body
get '/body/?' do
  request.body()
end

post '/body/?' do
  request.body()
end

put '/body/?' do
  request.body()
end

delete '/body/?' do
  request.body()
end

# return requests http status code
get %r{/([0-9]{3})} do
  status_code = params['captures'].first.to_i
  halt status_code, {'Content-Type' => 'text/plain'}, "returned #{status_code}"
end
