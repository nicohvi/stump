require 'stump'
require 'rack'

describe Stump::AccessLog do

  let(:app) { ->(env) { [200, env, "app"] } }
  let :middleware do
    Stump::AccessLog.new app
  end

  after :all do
    File.delete('tmp/test.log')
  end

  it 'should log requests to STDOUT' do
    logger = Stump::Logger.new
    $stdout.should_receive(:write)
    middleware.call env_for '/'
  end

  it 'should log requests to supplied file' do
    logger = Stump::Logger.new 'tmp/test.log'
    middleware.call env_for '/'
    File.exists?('tmp/test.log').should eq(true)
  end

  def env_for(url)
    Rack::MockRequest.env_for(url)
  end

end
