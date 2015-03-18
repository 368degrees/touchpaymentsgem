require 'active_model'

module TouchPayments::Resources
  
  class BaseResource
     include ActiveModel::Model
     include ActiveModel::AttributeMethods
     include ActiveModel::Serializers::JSON
    
    
    
    def initialize(opts)
      raise "Invalid data passed to initialize object" if !opts.is_a?(Hash)
      @attributes = {}
      add_attrs(opts)           
    end  
    
    def attributes
      @attributes
    end  
    
    def to_s
      to_json
    end  
    
    private
    
    def add_attrs(attrs)
      attrs.each do |var, value|
        class_eval { attr_accessor var.to_sym }
        instance_variable_set "@#{var}", value        
        @attributes[var] = value
      end
    end
    
  end
  
end  