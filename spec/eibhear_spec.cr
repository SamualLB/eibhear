require "./spec_helper"

describe Eibhear do
  it "can create a translatable model" do
    movie = Movie.new
    tr = MovieTranslation.new
    movie.imdb_id = "tt8075192"
    movie.tmdb_id = 505192
    movie.save!
    tr.movie = movie
    tr.locale = "en"
    tr.name = "Shoplifters"
    tr.save!
    Movie.all.first.id.should eq movie.id
    movie.name.should eq "Shoplifters"
    movie.translations.size.should eq 1
  end

  it "can create a new translation from the parent" do
    movie = Movie.new
    movie.imdb_id = "tt"
    movie.tmdb_id = 12345
    movie.save
    (tr = movie.new_movie_translation(locale: "jp", name: "万引き家族")).save
    tr.should be_a MovieTranslation
    tr.movie.id.should eq movie.id
    tr.locale.should eq movie.translations["jp"].locale
  end

  it "can create a new translation without named locale argument" do
    movie = Movie.new
    movie.imdb_id = "tt"
    movie.tmdb_id = 123456
    movie.save
    (tr = movie.new_movie_translation("de", name: "fdsfsd")).save
    tr.should be_a MovieTranslation
    tr.movie.id.should eq movie.id
    tr.locale.should eq movie.translations["de"].locale
  end
end
