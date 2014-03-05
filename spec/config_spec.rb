require 'stump'

describe Stump::Config do

  before(:each) do
    @log_file_name = 'tmp/test.log'
  end

  it 'does not create a file when one is not specified in the config' do
    Stump::Config.init()
    File.exists?(@log_file_name).should eq(false)
  end

  it 'creates a new log file if none exists' do
    Stump::Config.init({path: @log_file_name}).should be_a(Logger)
    File.exists?(@log_file_name).should eq(true)
  end


  it 'logs to file when a file is specified in the config' do
    logger = Stump::Config.init({path: @log_file_name})
    logger.info('log entry')
    File.readlines(@log_file_name).any? { |line| line['log entry'] }.should eq(true)
  end

  after(:all) do
    File.delete('tmp/test.log')
  end

end