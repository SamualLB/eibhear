require "./spec_helper"

describe Eibhear do
  it "can create a translatable model" do
    (movie = Movie.new).should be_a Movie
    (tr = MovieTranslation.new).should be_a MovieTranslation
    movie.imdb_id = "tt8075192"
    movie.tmdb_id = 505192
    movie.save
    tr.movie = movie
    tr.locale = "en"
    tr.name = "Shoplifters"
    tr.save
    Movie.all.first.id.should eq movie.id
    movie.name.should eq "Shoplifters"
    movie.translations.size.should eq 1
  end

  it "can create a new translation from the parent" do
    movie = Movie.new
    #tr = movie.new_translation("jp", name: "万引き家族")
  end
end
