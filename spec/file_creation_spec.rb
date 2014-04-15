require 'stump'
require 'logger'

describe 'file creation' do

  before :all do
    @log_file_name = 'tmp/test.log'
  end

  it 'does not create a file when one is not specified in the config' do
    logger = Stump::Logger.new
    File.exists?(@log_file_name).should eq(false)
  end

  it 'creates a new log file if none exists and path is supplied' do
    logger = Stump::Logger.new(@log_file_name).should be_a(Logger)
    File.exists?(@log_file_name).should eq(true)
  end

  after :all do
    File.delete('tmp/test.log')
  end

end
