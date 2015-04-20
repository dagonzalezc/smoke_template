# ****************************** Using Owner ****************************

require_relative './../config/config'
require './lib/actions'

# ****************************** Add we Own Created Methods ****************************

require './lib/methods/createsession'
require './lib/methods/procesar'
require './lib/methods/billpay'
require './lib/methods/login'
require './lib/methods/query'



module Methods

	class Manager
		@parsed_request = {}
		def self.request(method_request, input_params = nil)
			
			content_type = nil
			file_methods = Configuration.get_methods

			file_methods['partner']['endpoints'].each_value do |endpoint|
				if endpoint['url'].to_s == method_request.path_info.to_s 
					content_type = endpoint['inputType'].downcase.to_sym
				end
			end

			case content_type
				when :xml
					require './lib/parsers/xml_parser'			
					@parsed_request= XmlParser.get_parser(method_request.body) 

				when :json			
					require './lib/parsers/json_parser'
					@parsed_request = JsonParser.get_parser(method_request.body)
				when :url
					require './lib/parsers/url_parser'
					@parsed_request = UrlParser.get_parser(method_request.body,input_params)
					
			end

			#@parsed_request.inspect.to_s

			if file_methods['partner']['methods'].has_key?(@parsed_request[:body][:method])
				action= @parsed_request[:body][:method].capitalize
				obj =  Object.const_get('Methods').const_get(action.to_s).new
				obj.send(@parsed_request[:body][:method].downcase,@parsed_request)
			else
				{ :view => :error, :valid_action => false, :params => {:ErrorMesage => "Not Added method"}}	
			end
			#file_methods['partner']['worker'].inspect.to_s
		end

	end
end