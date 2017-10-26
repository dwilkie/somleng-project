$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'somleng_project'
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }
