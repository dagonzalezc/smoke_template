# ****************************** Using Owner ****************************

require './lib/methods/createsession'
require './lib/methods/procesar'
require './lib/methods/billpay'
require './lib/methods/login'
require './lib/actions'

require 'nokogiri'

module Methods
	
	def manage_request(method_request)
		data = Nokogiri::XML(method_request.read).remove_namespaces!

		name = data.xpath("//Body")[0].element_children[0].name

		case name
			when "login"				
				Login.login(data.xpath("//Body"))
				#Actions.get_actions.inspect.to_s
			when "billpay"
				#Pay.pay(data)
			when "createsession"
				#CreateSession.create_session(data)
			when "procesar"
		end
			
	end

end