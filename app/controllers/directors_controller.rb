class DirectorsController < ApplicationController
  def index
    matching_directors = Director.all
    @list_of_directors = matching_directors.order({ :created_at => :desc })

    render({ :template => "director_templates/index" })
  end

  def director_params
    # Adjust attributes as needed
    params.permit(:name, :dob, :bio, :image)
  end

  def insert
    @director = Director.new(name: params[:name], dob: params[:dob], bio: params[:bio], image: params[:image])
    if @director.save
      redirect_to "/directors", notice: 'Director was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def modify
    @director = Director.find(params[:path_id])
    if @director.update(director_params)
      redirect_to "/directors/#{params[:path_id]}", notice: 'Director was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def delete
    @director = Director.find(params[:path_id])
    @director.destroy
    redirect_to "/directors", notice: 'Director was successfully deleted.'
  end

  def show
    the_id = params.fetch("path_id")
    matching_directors = Director.where({ :id => the_id })
    @the_director = matching_directors.at(0)
    render({ :template => "director_templates/show" })
  end

  def max_dob
    directors_by_dob_desc = Director.
      all.
      where.not({ :dob => nil }).
      order({ :dob => :desc })

    @youngest = directors_by_dob_desc.at(0)

    render({ :template => "director_templates/youngest" })
  end

  def min_dob
    directors_by_dob_asc = Director.
      all.
      where.not({ :dob => nil }).
      order({ :dob => :asc })
      
    @eldest = directors_by_dob_asc.at(0)

    render({ :template => "director_templates/eldest" })
  end
end
