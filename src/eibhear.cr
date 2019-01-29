require "granite/adapter/pg"
require "./eibhear/*"

module Eibhear
  VERSION = "0.0.1"
end

Granite::Adapters << Granite::Adapter::Pg.new({name: "pg", url: "postgres://postgres:@localhost:5432/eibhear_test"})

class Test < Granite::Base
  include Eibhear::Translatable
  adapter pg
  eibhear_adapter pg

  field slug : String

  i18n_field :test_field
end

class Test3 < Granite::Base
  include Eibhear::Translatable

  adapter pg

  i18n_field :third_field

  eibhear_table_name test_3_translation
end

test = Test.new

#test.id = 1
#test.slug = "test slug"
#test.test_field "en"

#Test.find_by(slug: "test_slug")

#Test::Translation.find_by(test_id: 1)

test = Test.find(1)

#pp test.test_field if test
#puts Test.find(1).as(Test).id

test.{{Test::PRIMARY[:name]}}()

#Test::Translation.find_by(test_id: {{Test::PRIMARY[:name]}}(), locale_id: locale)
