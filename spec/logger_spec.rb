require 'stump'
require 'logger'

describe 'logging to STDOUT' do

  it 'should log to STDOUT when no path is supplied' do
    logger = Stump::Logger.new
    $stdout.should_receive(:write)
    logger.info('log entry')
  end

  it 'should log to STDOUT when a path is supplied as well' do
    logger = Stump::Logger.new 'tmp/test.log'
    $stdout.should_receive(:write)
    logger.info('log entry')
  end

end

describe 'logging to files' do

  before :all do
    @log_file_name = 'tmp/test.log'
  end

  after :all do
    File.delete('tmp/test.log')
  end

  it 'logs to supplied file' do
    logger = Stump::Logger.new @log_file_name
    logger.info('log entry')
    File.readlines(@log_file_name).any? { |line| line['log entry'] }.should eq(true)
  end

end
