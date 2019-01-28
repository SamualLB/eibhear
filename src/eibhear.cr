require "granite/adapter/pg"
require "./eibhear/*"

module Eibhear
  VERSION = "0.0.1"
end

Granite::Adapters << Granite::Adapter::Pg.new({name: "pg", url: "postgres://postgres:@localhost:5432/thtrdb_api_development"})

class Test < Granite::Base
  include Eibhear::Translatable
  adapter pg
  eibhear_adapter pg


  i18n_field :test_field
end

class Test3 < Granite::Base
  include Eibhear::Translatable

  adapter pg

  i18n_field :third_field

  eibhear_table_name test_3_translation
end

Test.new.test_field "en"


