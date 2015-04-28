require_relative './../../config/config'

module Faker
	class Name

		attr_accessor :file, :language

		def config_file
			file = file || Configuration.get_faker
		end

		def get_name

			self.language = self.language || 'es'			
			lists = config_file['faker'][self.language]['names']['lists']
			patterns = config_file['faker'][self.language]['names']['patterns']
			pattern = patterns.values[rand(0..patterns.length - 1 )]	
			pattern = pattern.gsub("["," ")
			pattern = pattern.gsub("]"," ")			
			words = pattern.split(' ')

			words.each_with_index do |value, index|
				if lists.has_key?(value)
					words[index] = lists[value][rand(0..lists[value].length - 1)].to_s		
				end
			end

			words.join(" ")

		end
	end

	class Address
		attr_accessor :file, :language

		def config_file
			file = file || Configuration.get_faker
		end

		def get_address

			self.language = self.language || 'es'

			lists = config_file['faker'][self.language]['address']['lists']
			patterns = config_file['faker'][self.language]['address']['patterns']
			pattern = patterns.values[rand(0..patterns.length - 1 )]	
			pattern = pattern.gsub("["," ")
			pattern = pattern.gsub("]"," ")			
			words = pattern.split(' ')

			words.each_with_index do |value, index|
				if lists.has_key?(value)
					words[index] = lists[value][rand(0..lists[value].length - 1)].to_s		
				end
			end

			words.join(" ")
		end

	end

	class Amount
		attr_accessor :file, :limit, :format
		def get_amount
			self.limit = self.limit || 100
			return rand(0..self.limit).to_s + "." + rand(0..99).to_s 
		end
	end
	
end

