class MoviesController < ApplicationController
  def index
    matching_movies = Movie.all
    @list_of_movies = matching_movies.order({ :created_at => :desc })

    render({ :template => "movie_templates/index" })
  end

  def movie_params
    # Adjust attributes as needed
    params.permit(:title, :year, :duration, :description, :image, :director_id)
  end

  def insert
    @movie = Movie.new(title: params[:title], year: params[:year], duration: params[:duration], description: params[:description], image: params[:image], director_id: params[:director_id])
    if @movie.save
      redirect_to "/movies", notice: 'movie was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def modify
    @movie = Movie.find(params[:path_id])
    if @movie.update(movie_params)
      redirect_to "/movies/#{params[:path_id]}", notice: 'movie was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def delete
    @movie = Movie.find(params[:path_id])
    @movie.destroy
    redirect_to "/movies", notice: 'movie was successfully deleted.'
  end

  def show
    the_id = params.fetch("path_id")

    matching_movies = Movie.where({ :id => the_id })
    @the_movie = matching_movies.at(0)

    render({ :template => "movie_templates/show" })
  end
end
