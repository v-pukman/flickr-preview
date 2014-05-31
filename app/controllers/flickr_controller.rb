class FlickrController < ApplicationController
  
  def index
  end

  def photos
  	agent = FlickrAgent.new
  	query = params[:query]  	
  	agent.async.request_photos(query)
  end

end
