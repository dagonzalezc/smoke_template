require 'spec_helper'
require_relative './../lib/validators/validator'


describe Validator::Validate, focus: true do 
	
	include Validator

	it "Validate Structure" do

		# *************************** Use a method added in methods.yml, validator.yml and errors.yml ***************************

		hash_input = {:body =>{:method => "query", :fields=>{"NomEmpresa" => "enee", "operacion" => "1234", "account" => "25"}}}

      	validate = Validator::Validate.new
      	result = validate.method_structure(hash_input)

      	if result.is_a?(String)

      		valid = !result.index("Dependence Of").nil? || !result.index("Misses Parameter").nil?

      		expect(valid).to be(true)
      	else
      		expect(result).to be(true)
      	end 

	end

	it " Validate Rules " do

		# *************************** Use a method added in methods.yml, validator.yml and errors.yml ***************************

		hash_input = {:body =>{:method => "query", :fields=>{"NomEmpresa" => "enee", "operacion" => "1234", "account" => "0"}}}

      	validate = Validator::Validate.new

      	result = validate.method_rules(hash_input)

      	if result.is_a?(String)

      		valid = !result.index("not pass rule").nil? 

      		expect(valid).to be(true)

      	else
      		expect(result).to be(true)
      	end 

	end
end