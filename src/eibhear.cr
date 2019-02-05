require "granite/adapter/pg"
require "./eibhear/*"
require "http"

class HTTP::Server::Context
  property locales = ["en"] of String
end

module Eibhear
  VERSION = "0.0.1"

  def self.configure
    yield config
  end

  def self.config
    @@config ||= Config.new
  end
end

#Eibhear.configure do |eibhear|
#  eibhear.available_locales = ["gr", "de", "fr", "en"]
#end
