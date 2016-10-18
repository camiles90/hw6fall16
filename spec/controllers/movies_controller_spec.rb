require 'rails_helper'
require 'spec_helper'

describe MoviesController do
  describe 'searching TMDb' do
   it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb) {[double('movie1'), double('movie2')]}
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end  
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(fake_results)
    end
    it 'should reload the index page when no input is entered and the button is pushed' do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:search_terms => ''}
      expect(response).to redirect_to(movies_path)
    end
    it 'should reload the index page when the search bar has contents but no movie is found' do
      post :search_tmdb, {:search_terms => 'asdfghjkl'}
      allow(Movie).to receive(:find_in_tmdb)
      expect(response).to redirect_to(movies_path)
    end 
  end
  
  describe 'adding from TMDb' do
        it 'should redirect to movies if no movies selected' do
          allow(Movie).to receive(:add_selected_movies)
          post :add_selected_movies, {}
          expect(response).to redirect_to(movies_path)
        end
        
        it 'should call create model method' do
          fake_results = [double('movie3')]
          expect(Movie).to receive(:add_selected_movies).with(['608']). and_return(fake_results)
          post :add_selected_movies, {:tmdb_movies => {'608':'1'}}
        end
    end
end
