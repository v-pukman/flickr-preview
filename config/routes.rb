FlickrPreview::Application.routes.draw do  
  get "flickr/photos", :constraints => { :only_ajax => true }
  root :to => "flickr#index"  
end
