require 'stump'
describe Stump::Config do

  it 'creates a new log file if none exists' do
    Stump::Config.init({path: 'tmp/test.log'}).should be_a(Logger)
    File.exists?('tmp/test.log').should eq(true)
  end

  after(:all) do
    File.delete('tmp/test.log')
  end

end