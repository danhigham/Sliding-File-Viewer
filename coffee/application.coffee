if google?
  google.load "jquery", "1.6.1"
  google.load "jqueryui", "1.8.13"
  # google.load "webfont", '1'

  google.setOnLoadCallback () ->
    # WebFont.load
    #   google:
    #     families: ['Changa One', 'Permanent Marker','Ubuntu Mono']
    
$(document).ready ->    
  window.file_viewer = new SlidingFileViewer "file_viewer", "/fs/blah.json"
  window.file_viewer.on_file_select (path) ->
    alert path