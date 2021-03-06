class ApiController < ApplicationController

  # retrieve data from weeatt API and post to our DB at addRecipe
  def seed  
  end

  # action data posting to DB
  def addRecipe

    params['results'].each do |result|
      recipe = Recipe.new
      recipe.title = result[1]['name']
      if result[1]['images'] &&
        result[1]['images'].values.first["large_image_path"] != '/photos/large/missing.png'
        # deal with ridiculous image nesting
        recipe.image_url = result[1]['images'].values.first["large_image_path"]
      else
        recipe.image_url = nil # for recipes with no images
      end
      recipe.description = result[1]['description']
      recipe.method = result[1]['instructions']
      recipe.ingredients = result[1]['ingredients']
      recipe.cook_time = 15 + rand(26)
      recipe.nbr_times_cooked = 5 + rand(146)
      recipe.user_rating = 1 + rand(5)
      if recipe.image_url
        recipe.save
      else
        next
      end
    end

    redirect_to root_path # lol this don't work no good

  end

  # supply json search results from DB
  def list
    
    recipes = Recipe.all
    render :json => recipes.to_json

  end

  # supply json recipe detail from DB
  def show

    recipe = Recipe.find(params[:id])
    render :json => recipe.to_json

  end


end

# add if r.save alternatives
# add check for duplicates;
# consider method for cook_time
# consider method for nbr_times_cooked
# consider method for user rating

# filter for relevant recipes at some point