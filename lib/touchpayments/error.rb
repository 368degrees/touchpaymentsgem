module TouchPayments
  module Error
    class InvalidResponse < StandardError
      def initialize()
        super('Invalid or empty response from server.')
      end
    end

    class InvalidJSON < StandardError
      def initialize(json)
        super("Couldn't parse JSON string received from server:\n#{json}")
      end
    end

    class ServerError < StandardError
      attr_reader :code, :response_error

      def initialize(code, message)
        @code = code
        @response_error = message
        super("Server error #{code}: #{message}")
      end
    end
    
    class UnsupportedRequestError < StandardError
      
      def initialize(method)
        super("Unsupported request #{method}, supported methods include #{TouchPayments::Configuration::VALID_METHODS}")
      end
    end  
    
  end
end