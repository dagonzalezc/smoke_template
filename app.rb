require './lib/methods'
# ****************************** Using External ****************************
require 'sinatra'
require 'sinatra/base'
require 'sinatra/respond_with'


class SmokeTemplate < Sinatra::Base

	include Methods

	configure do
		set :app_file, File.expand_path('../', __FILE__)
		set :root, File.dirname(__FILE__)
		set :views, File.expand_path('../views', __FILE__)
		register Sinatra::RespondWith
	end

	post '/', :provides =>[:xml] do
		use_response = manage_request(request.body)
		use_response.to_s
		#respond_with use_response[:view],:parametros => use_response[:params]	
	end

	get '/', :provides =>[:xml] do
		use_response = manage_request(request.body)
		respond_with use_response[:view],:parametros => use_response[:params]		
	end

end