class FlickrAgent
	CACHE_TIME = 5.minute
	FAYE_URI = "http://localhost:9292/faye"

	include SuckerPunch::Job

	# gets photo urls in json
	# sends message with photos to faye
	def request_photos(query)
		photos = grab_photos_by_tags(query)
		
		message = { :channel => "/flickr_response", :data => photos }
		uri = URI.parse(FAYE_URI)
		
		Net::HTTP.post_form(uri, :message => message.to_json)
	end

	private

		#grab photos from flickr by tags, choosing small version of image
		#no pages yet
		#uses redis to cache results
		#returns json
		def grab_photos_by_tags(tags)
			tags = tags.to_s
			return "[]" if tags.empty?

			if redis.get(tags).nil?
				list = flickr.photos.search(:tags => tags)
				urls = []
				list.each { |photo_info| urls << FlickRaw.url_s(photo_info) }
				urls = urls.to_json
				redis.set(tags, urls)
				redis.expire(tags, CACHE_TIME)
				urls
			else
				redis.get(tags)
			end 
		end
end