require 'helper'
 
describe 'configuration' do
 
  describe '.api_key' do
    it 'should return default key' do
      TouchPayments.api_key.must_equal TouchPayments::Configuration::DEFAULT_API_KEY
    end
  end
 
  describe '.format' do
    it 'should return default format' do
      TouchPayments.format.must_equal TouchPayments::Configuration::DEFAULT_FORMAT
    end
  end
 
  describe '.user_agent' do
    it 'should return default user agent' do
      TouchPayments.user_agent.must_equal TouchPayments::Configuration::DEFAULT_USER_AGENT
    end
  end
 
  describe '.method' do
    it 'should return default http method' do
      TouchPayments.method.must_equal TouchPayments::Configuration::DEFAULT_METHOD
    end
  end
  
  after do
    TouchPayments.reset
  end
 
  describe '.configure' do
    TouchPayments::Configuration::VALID_CONFIG_KEYS.each do |key|
      it "should set the #{key}" do
        TouchPayments.configure do |config|
          config.send("#{key}=", key)
          TouchPayments.send(key).must_equal key
        end
      end
    end
  end
 
end