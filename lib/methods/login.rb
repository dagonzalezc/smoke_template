require_relative './../validators/validator'
require 'yaml'
require 'nokogiri'

module Methods
	class Login
		
		include Validator

		def self.login (value)			 
			#Validator::Validate.method_structure('login',value).to_s
			#if Validator::Validate.method_rules('login',value) and
			# 	Validator::Validate.method_structure('login',value) then

			#	response =  { :view => :success, :valid_action => true, :params => {:valor1 => "12345678",:valor2 =>"2", :add => false}}

			#else
			#	response =  { :view => :error, :valid_action => false, :params => {:valor1 => "12345678",:valor2 =>"2", :add => false}}
			#end
			#Actions.set_action("login")
			#Actions.set_action("login")
			#Actions.set_action("createsession")

			#Validator::Validate.method_rules('login',value)
			Validator::Validate.testing

		end

	end
end