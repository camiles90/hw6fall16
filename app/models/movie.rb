class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
 class Movie::InvalidKeyError < StandardError ; end
  #found most of this on github
  def self.find_in_tmdb(string)#add Api key
    begin #invalid key check
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    matching_movies = Tmdb::Movie.find(string)
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
  
  #found on github
  def self.find_rating(movieID)
    movies = Tmdb::Movie.releases(movieID)['countries']
    if movies.nil? then return "N/A" end
    for i in 0..movies.size-1
      if (movies[i]["iso_3166_1"] == "US" && !movies[i]["certification"].blank?) then return movies[i]['certification'] end  
    end
       "NR" #add for Not rated
  end
  
  def self.add_selected_movies(movies)
    for i in 0..movies.size-1 #iterate through movies keys
      tmdbMovie = Tmdb::Movie.detail(movies[i]) #get the attributes
      movie = Movie.new() # create new movie object
      movie.title = tmdbMovie['title'] #add title
      movie.release_date = tmdbMovie['release_date'] #add release date
      movie.rating = find_rating(movies[i]) #set rating
      movie.description = tmdbMovie['overview']#set overview
      movie.save! #save the movie
    end
  end
end