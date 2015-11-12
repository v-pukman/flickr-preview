$(document).ready ->

  container = $("#photos-container")
  status = $("#status-bar")
  search_btn = $("#search-btn")
  query_input = $("#query-input")

  # init faye client
  # faye gets loaded flickr's photos

  faye = new Faye.Client("http://localhost:9292/faye")
  faye.disable("websocket");
  faye.subscribe "/flickr_response", (data) ->
    console.log("data loaded")

    status.hide()

    photos = JSON.parse(data)
    for photo in photos
      container.append('<img src="'+photo+'">')


  # add listener to search button
  # it sends request to server by ajax

  search_btn.click ->
    container.empty()

    $.ajax "/flickr/photos",
      type: "get",
      data: { query: query_input.val() },
      error: () ->
        status.text("Oops! Try again!")
        status.show()
      success: (data) ->
        console.log("request sent")

        status.text("Loading...")
        status.show()

    false
