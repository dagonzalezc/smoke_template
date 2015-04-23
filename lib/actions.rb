require 'securerandom'
require_relative './../config/config'

class Actions

  @actions = Hash.new
  @time_out = nil

  def self.add(action, attributes = nil)
    a_action = Action.new(action,attributes)
    @actions[a_action.uid] = a_action
    a_action
  end

  def self.get_actions
    @actions
  end
  
  def self.update
    file_methods = Configuration.get_methods
    if file_methods['partner']['environment']['actions']['timeout']
      @time_out = file_methods['partner']['environment']['actions']['timeout']
    end

    if !@time_out.nil?
      @actions.each do |key_action, value_action|
        if  (Time.now - value_action.time) >= @time_out
          @actions.delete(key_action)
        end
      end
    end 
  end
end 

class Action
  attr_accessor :uid, :time, :name, :data
  def initialize(action_name, attributes = nil)
    @uid = SecureRandom.urlsafe_base64(nil, false)[0,20].upcase
    @time = Time.now
    @name = action_name
    @data= attributes
  end
end

