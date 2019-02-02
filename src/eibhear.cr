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

Eibhear.configure do |eibhear|
  eibhear.available_locales = ["gr", "de", "en"]
end

Granite::Adapters << Granite::Adapter::Pg.new({name: "pg", url: "postgres://postgres:@localhost:5432/eibhear_test"})

class Test < Granite::Base
  include Eibhear::Base
  adapter pg

  field slug : String

  has_translations translations : TestTranslation, :test_field!, other_field
end

class TestTranslation < Granite::Base
  include Eibhear::Translatable

  field test_field : String
  field other_field : String
end

class Test3 < Granite::Base
  include Eibhear::Base

  adapter pg

  has_translations Test3Translation, :third_field
end

class Test3Translation < Granite::Base
  include Eibhear::Translatable

  adapter pg

  field third_field : String
end
