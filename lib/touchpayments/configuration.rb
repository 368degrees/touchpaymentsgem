#############
# TODO: Remove this block
require 'openssl'

warn_level = $VERBOSE
$VERBOSE = nil
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
$VERBOSE = warn_level
##############

module TouchPayments
  module Configuration
    VALID_CONNECTION_KEYS = [:endpoint, :user_agent, :method].freeze
    VALID_METHODS         = [:ping, :apiActive, :getMaximumCheckoutValue, :getJavascriptSources, :getFeeAmount, :getOrder].freeze
    VALID_OPTIONS_KEYS    = [:api_key, :format].freeze
    VALID_CONFIG_KEYS     = VALID_CONNECTION_KEYS + VALID_OPTIONS_KEYS
 
    DEFAULT_ENDPOINT    = 'https://test.touchpayments.com.au/api/v2'
    DEFAULT_METHOD      = :post
    DEFAULT_USER_AGENT  = "TouchPayments API Ruby Gem #{TouchPayments::VERSION}".freeze
 
    DEFAULT_API_KEY      = "fde25580b4e0f7371dc7e9f5203332041cd402a098d3b350edadbc2f2b7eff7d8aeea097"
    DEFAULT_FORMAT       = :json
    
    JSONRPC_VERSION     = "2.0".freeze
    
    ENVIRONMENT         = :dev

    attr_accessor *VALID_CONFIG_KEYS
    attr_accessor *VALID_METHODS
 
    def configure
      yield self
    end  
    
    def self.extended(base)
      base.reset
    end
 
    def reset
      self.endpoint   = DEFAULT_ENDPOINT
      self.method     = DEFAULT_METHOD
      self.user_agent = DEFAULT_USER_AGENT
 
      self.api_key    = DEFAULT_API_KEY
      self.format     = DEFAULT_FORMAT
    end
    
    def opts_hash
      Hash[ * VALID_CONFIG_KEYS.map { |key| [key, send(key)] }.flatten ]
    end
 
  end # Configuration
end