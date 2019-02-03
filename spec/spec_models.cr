{% begin %}
  {% adapter_literal = env("CURRENT_ADAPTER").id %}
  {% adapter_literal = "pg".id %}

  class Movie < Granite::Base
    include Eibhear::Base
    adapter {{ adapter_literal }}

    field imdb_id : String
    field tmdb_id : Int32

    has_translations MovieTranslation, :name
  end

  class MovieTranslation < Granite::Base
    include Eibhear::Translatable
    adapter {{ adapter_literal }}

    table_name :movie_translation

    belongs_to :movie

    field movie_id : Int64
    field name : String
  end

Movie.migrator.drop_and_create
MovieTranslation.migrator.drop_and_create

{% end %}
