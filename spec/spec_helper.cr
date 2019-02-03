require "mysql"
require "pg"
require "sqlite3"
require "granite"
require "../lib/granite/src/adapter/**"

#Granite::Adapters << Granite::Adapter::Mysql.new({name: "mysql", url: ENV["MYSQL_DATABASE_URL"]})
#Granite::Adapters << Granite::Adapter::Pg.new({name: "pg", url: ENV["PG_DATABASE_URL"]})
#Granite::Adapters << Granite::Adapter::Sqlite.new({name: "sqlite", url: ENV["SQLITE_DATABASE_URL"]})

Granite::Adapters << Granite::Adapter::Pg.new({name: "pg", url: "postgres://postgres:@localhost:5432/eibhear_test"})

Spec.before_each do
  Granite.settings.default_timezone = Granite::TIME_ZONE
end

require "spec"
require "../src/eibhear"
require "./spec_models"
