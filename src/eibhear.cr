require "granite/adapter/pg"
require "./eibhear/*"

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
  eibhear.locales = ["fr", "de", "en"]
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

test = Test.find!(1)

puts test.test_field
