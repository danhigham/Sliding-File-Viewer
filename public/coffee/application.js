(function() {
  if (typeof google !== "undefined" && google !== null) {
    google.load("jquery", "1.6.1");
    google.load("jqueryui", "1.8.13");
    google.setOnLoadCallback(function() {});
  }
  $(document).ready(function() {
    window.file_viewer = new SlidingFileViewer("file_viewer", "/fs/blah.json");
    return window.file_viewer.on_file_select(function(path) {
      return alert(path);
    });
  });
}).call(this);
