class Actions
	@actions = Hash.new

	def self.add(action)
		if @actions.has_key?(action)
			@actions[action] +=1
		else
			@actions[action] = 1
		end
	end

	def self.get_actions
		@actions
	end
	
end 
