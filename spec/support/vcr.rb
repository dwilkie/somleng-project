require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
end

RSpec.configure do |config|
  config.around(:vcr => true) do |example|
    cassette = example.metadata[:cassette] || raise(ArgumentError, "You must specify a cassette")
    vcr_options = example.metadata[:vcr_options] || {}
    VCR.use_cassette(cassette, vcr_options) { example.run }
  end
end

