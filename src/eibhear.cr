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

def create_context(request)
  io = IO::Memory.new
  response = HTTP::Server::Response.new(io)
  HTTP::Server::Context.new(request, response)
end

Eibhear.configure do |eibhear|
  eibhear.available_locales = ["gr", "de", "en"]
end

Granite::Adapters << Granite::Adapter::Pg.new({name: "pg", url: "postgres://postgres:@localhost:5432/eibhear_test"})

class Test < Granite::Base
  include Eibhear::Translatable
  adapter pg
  eibhear_adapter pg

  field slug : String

  eibhear_field :test_field
end

class Test3 < Granite::Base
  include Eibhear::Translatable

  adapter pg

  eibhear_field :third_field

  eibhear_table_name test_3_translation
end
