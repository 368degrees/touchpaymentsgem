require 'multi_json'
require 'faraday'
require 'touchpayments/configuration'
require 'touchpayments/request'
require 'touchpayments/response'
require 'touchpayments/error'
require 'touchpayments/version'

module TouchPayments
  
     def self.logger=(logger)
      @logger = logger
    end

    def self.logger
      @logger
    end
  
    def self.decode_options=(options)
      @decode_options = options
    end

    def self.decode_options
      @decode_options
    end

    @decode_options = {}
  
    class BaseClient   
      
      attr_accessor *Configuration::VALID_CONFIG_KEYS

      def self.make_id
        rand(10**12)
      end

      def initialize(options={})     
        @helper = ::TouchPayments::Helper.new(options)
       
      end

      def to_s
        inspect
      end

      #def inspect
      #  "#<#{self.class.name}:0x00%08x>" % (__id__ * 2)
      #end

      def class
        (class << self; self end).superclass
      end

    private
      def raise(*args)
        ::Kernel.raise(*args)
      end
   end # BaseClient
 
  class Client < BaseClient   
 
    def initialize(opts={})
      super(opts)
      # Merge the config values from the module and those passed
      # to the client.    
      
      merged_options = TouchPayments.opts_hash.merge(opts)
 
      #puts "#{merged_options}"
      
      # Copy the merged values to this client and ignore those
      # not part of our configuration
      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
    end
    
    def method_missing(method, *args, &block)    
      if Configuration::VALID_METHODS.include? method.to_sym
         invoke(method, args) 
      else
        raise TouchPayments::Error::UnsupportedRequestError.new(method)
      end  
    end

    def invoke(method, args, options = nil)
      resp = send_single_request(method.to_s, args, options)

      begin
        data = MultiJson.decode(resp, ::TouchPayments.decode_options)
      rescue
        raise TouchPayments::Error::InvalidJSON.new(resp)
      end

      process_single_response(data)
    rescue => e
      e.extend(TouchPayments::Error)
      raise
      resp
    end
    
    private
    
    def send_single_request(method, args, options)      
      args.unshift(api_key) if args
      #args << self.api_key if args
      post_data = ::MultiJson.encode({
        'jsonrpc' => TouchPayments::Configuration::JSONRPC_VERSION,
        'method'  => method,
        'params'  => args,
        'id'      => TouchPayments::BaseClient.make_id
      })
      
      puts "request: #{post_data}"
      
      resp = @helper.connection.post(self.endpoint, post_data, @helper.options(options))

      puts "response: #{resp.body}"
      
      if resp.nil? || resp.body.nil? || resp.body.empty?
        raise TouchPayments::Error::InvalidResponse.new
      end

      resp.body
    end
    
    def process_single_response(data)
      raise TouchPayments::Error::InvalidResponse.new unless valid_response?(data)

      if data && data['error']
        code = data['error']['code']
        msg = data['error']['message']
        raise TouchPayments::Error::ServerError.new(code, msg)
      end

      data['result']
    end
    
     def valid_response?(data)
        return false if !data.is_a?(::Hash)
        return false if data['jsonrpc'] != TouchPayments::Configuration::JSONRPC_VERSION
        return false if !data.has_key?('id')
        return false if data.has_key?('error') && data.has_key?('result')

        if data.has_key?('error')
          if !data['error'].is_a?(::Hash) || !data['error'].has_key?('code') || !data['error'].has_key?('message')
            return false
          end

          if !data['error']['code'].is_a?(::Fixnum) || !data['error']['message'].is_a?(::String)
            return false
          end
        end

        true
     end  

 
  end # Client

  class Helper
    def initialize(options)
      @options = options
      @options[:content_type] ||= 'application/json'
      @connection = @options.delete(:connection)
    end

    def options(additional_options = nil)
      if additional_options
        additional_options.merge(@options)
      else
        @options
      end
    end

    def connection
      @connection || Faraday.new { |connection|
       #connection.response :logger, ::TouchPayments.logger
        connection.adapter Faraday.default_adapter
      }
    end
  end #helper
     
   class BatchClient < BaseClient
    attr_reader :batch

    def initialize(url, opts = {})
      super
      @batch = []
      @alive = true
      yield self
      send_batch
      @alive = false
    end

    def method_missing(sym, *args, &block)
      if @alive
        request = TouchPayments::Request.new(sym.to_s, args)
        push_batch_request(request)
      else
        super
      end
    end

  private
    def send_batch_request(batch)
      post_data = MultiJson.encode(batch)
      resp = @helper.connection.post(self.endpoint, post_data, @helper.options)
      if resp.nil? || resp.body.nil? || resp.body.empty?
        raise TouchPayments::Error::InvalidResponse.new
      end

      resp.body
    end

    def process_batch_response(responses)
      responses.each do |resp|
        saved_response = @batch.map { |r| r[1] }.select { |r| r.id == resp['id'] }.first
        raise TouchPayments::Error::InvalidResponse.new if saved_response.nil?
        saved_response.populate!(resp)
      end
    end

    def push_batch_request(request)
      request.id = TouchPayments::BaseClient.make_id
      response = TouchPayments::Response.new(request.id)
      @batch << [request, response]
      response
    end

    def send_batch
      batch = @batch.map(&:first) # get the requests
      response = send_batch_request(batch)

      begin
        responses = ::MultiJson.decode(response, ::JSONRPC.decode_options)
      rescue
        raise TouchPayments::Error::InvalidJSON.new(json)
      end

      process_batch_response(responses)
      @batch = []
    end
  end #BatchClient
     
end