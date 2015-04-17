require 'yaml'

class Error
	
	attr_accessor :error_container
	@service_name = nil
	@input_request = Hash.new
	@hash_magics = Hash.new
	@hash_lists = Hash.new
	@method_name = nil
	@magic_id = nil
	@magic_rule = nil


	def add_request(params)

		@input_request = params
		@method_name = params[:body][:method]

		if file_error['partner']['methods'][@method_name].has_key?('serviceId')
			service_param = file_error['partner']['methods'][@method_name]['serviceId']
			@service_name = get_value_of(params[:body][:fields],service_param)
		end
		if !@service_name.nil? and !@service_name.empty?
			if file_error['partner']['services'][@service_name]['methods'][@method_name].has_key?('magic')
				@magic_id = file_error['partner']['services'][@service_name]['methods'][@method_name]['magic']['inputId']
				@magic_rule = file_error['partner']['services'][@service_name]['methods'][@method_name]['magic']['rule']
			end				
		else
			if file_error['partner']['methods'][@method_name].has_key?('magic')
				@magic_id = file_error['partner']['methods'][@method_name]['magic']['inputId']
				@magic_rule = file_error['partner']['methods'][@method_name]['magic']['rule']
			end			
		end

		start_lists

	end

	def magic_input
		if @magic_id.nil?
			return nil
		end

		value_input = get_value_of(@input_request[:body][:fields],@magic_id)
		
		if !@magic_rule.nil? and !@magic_rule.empty?			
			arule = @magic_rule.gsub(@magic_id,"'" + value_input + "'")
			return eval(arule)
		end

		return value_input
	end

	def is_magic?(number)
		if @hash_magics.nil?
			return false
		end

		if number.nil? or number.empty?
			return false
		end

		@hash_magics.each_value do |magic|
			if magic['number'].to_s == number.to_s then
				return true
			end
		end

		false
	end

	def raise_error(error)
		raise error.code.to_s + error.message
	end

	def get_error(code, use_magic = false )
		if use_magic
			@hash_magics.each_value do |magic|
				if magic['number'].to_s == code.to_s
					return magic['error']
				end
			end			
		elsif !@hash_lists.nil? then
			@hash_lists.each do |key_group,group|
				if group.is_a?(Hash) then					
					group.each_value do |group_error|
						if group_error['code'].to_s == code.to_s
							return group_error
						end 
					end
				end
			end
		end

		{'code' => "0", 'message' => "Not Error added to List"}

	end

	private 

	def file_error
		@error_container =  @error_container || YAML.load_file(File.expand_path('../errors.yml', __FILE__))
	end

	def start_lists
		if !@service_name.nil?
			@hash_magics = file_error['partner']['services'][@service_name]['methods'][@method_name]['errors']['magics']
			@hash_lists = file_error['partner']['services'][@service_name]['methods'][@method_name]['errors']['lists']
		else
			@hash_magics = file_error['partner']['methods'][@method_name]['errors']['magics']
			@hash_lists = file_error['partner']['methods'][@method_name]['errors']['lists']
		end
	end

	def get_value_of(hash_input,key)
		value = nil
		if hash_input.has_key?(key)
			return hash_input[key]
		else
			hash_input.each do |input_key,input_value|
				if input_value.is_a?(Hash)
					value = get_value_of(input_value,key)
				end
			end
		end
		value
	end

end
