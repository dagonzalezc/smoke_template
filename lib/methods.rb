# ****************************** Using Owner ****************************

require './lib/methods/createsession'
require './lib/methods/procesar'
require './lib/methods/billpay'
require './lib/methods/login'
require './lib/actions'

require 'nokogiri'

module Methods
	
	def manage_request(method_request, content_type )

		if content_type.to_s.include?('xml') then
			require './lib/parsers/xml_parser'			
			parser= XmlParser.get_parser(method_request) 
		end

		case parser[:body][:method]
			when "login"
					Login.login(parser)
			when "procesar"
					Procesar.procesar(parser)
		end
		#parser		
	end

end