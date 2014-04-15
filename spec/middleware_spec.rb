require 'stump'
require 'rack'

describe Stump::AccessLog do

  let(:app) { ->(env) { [200, env, "app"] } }
  let(:log_file_name) { 'tmp/test.log' }

  after :each do
    File.delete(log_file_name) if File.exist?(log_file_name)
  end

  it 'should log requests to STDOUT' do
    logger = Stump::Logger.new
    middleware = Stump::AccessLog.new(app, logger)
    $stdout.should_receive(:write)
    middleware.call env_for '/'
  end

  it 'should create supplied log file' do
    logger = Stump::Logger.new log_file_name
    middleware = Stump::AccessLog.new(app, logger)
    middleware.call env_for '/'
    File.exists?(log_file_name).should eq(true)
  end

  it 'should log access log messages to supplied log file' do
    logger = Stump::Logger.new log_file_name
    middleware = Stump::AccessLog.new(app, logger)
    middleware.call env_for '/'
    File.readlines(log_file_name).length.should eq(1)
  end

  def env_for(url)
    Rack::MockRequest.env_for(url)
  end

end
