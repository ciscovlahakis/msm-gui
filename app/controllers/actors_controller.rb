class ActorsController < ApplicationController
  def index
    matching_actors = Actor.all
    @list_of_actors = matching_actors.order({ :created_at => :desc })

    render({ :template => "actor_templates/index" })
  end

  def actor_params
    # Adjust attributes as needed
    params.permit(:name, :dob, :bio, :image)
  end

  def insert
    @actor = Actor.new(name: params[:name], dob: params[:dob], bio: params[:bio], image: params[:image])
    if @actor.save
      redirect_to "/actors", notice: 'actor was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def modify
    @actor = Actor.find(params[:path_id])
    if @actor.update(actor_params)
      redirect_to "/actors/#{params[:path_id]}", notice: 'actor was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def delete
    @actor = Actor.find(params[:path_id])
    @actor.destroy
    redirect_to "/actors", notice: 'actor was successfully deleted.'
  end

  def show
    the_id = params.fetch("path_id")

    matching_actors = Actor.where({ :id => the_id })
    @the_actor = matching_actors.at(0)
      
    render({ :template => "actor_templates/show" })
  end
end
