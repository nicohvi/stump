require 'stump'
require 'support/mock_rack_app'
require 'rack'

describe Stump::Middleware do

  # let(:app) { MockRackApp.new }
  let(:app) { ->(env) { [200, env, "app"] } }
  # let(:request) { Rack::MockRequest.new(app) }

  let :middleware do
    Stump::Middleware.new(app)
  end

  before :all do
    logger = Stump::Logger.new
  end

  it 'should log requests to STDOUT' do
    $stdout.should_receive(:write)
    middleware.call env_for '/'
  end

  def env_for(url)
    Rack::MockRequest.env_for(url)
  end

end
