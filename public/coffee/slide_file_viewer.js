(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  window.SlidingFileViewer = (function() {
    function SlidingFileViewer(target_div, json_url, file_select_handler) {
      this.target_div = target_div;
      this.file_select_handlers = new Array;
      console.log("Init SFV");
      $("#" + this.target_div).append("<ul></ul>");
      this.main_div = $("#" + this.target_div);
      this.main_list = $("#" + this.target_div + " ul");
      this.register_template_helpers();
      this.load_template("folder.html", __bind(function(template) {
        return this.folder_template = template;
      }, this));
      this.load_template("file_viewer.html", __bind(function(template) {
        return this.main_template = template;
      }, this));
      $.ajax({
        url: json_url,
        dataType: "JSON",
        async: false,
        success: __bind(function(data) {
          return this.root = data;
        }, this)
      });
      this.create();
    }
    SlidingFileViewer.prototype.on_file_select = function(handler) {
      return this.file_select_handlers[this.file_select_handlers.length] = handler;
    };
    SlidingFileViewer.prototype.load_template = function(template_name, callback) {
      return $.ajax({
        url: "templates/" + template_name,
        async: false,
        type: "GET",
        success: __bind(function(data) {
          var template;
          template = Handlebars.compile(data);
          return callback(template);
        }, this)
      });
    };
    SlidingFileViewer.prototype.create_node_content = function(node, parent_path) {
      var child, _i, _len, _ref, _results;
      if (typeof node !== "string") {
        node.folder_id = _.uniqueId("folder_");
        node.parent_path = parent_path;
        node.children = _.sortBy(node.children, function(node) {
          return typeof node;
        });
        _ref = node.children;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          child = _ref[_i];
          _results.push(this.create_node_content(child, node.name));
        }
        return _results;
      }
    };
    SlidingFileViewer.prototype.create = function() {
      this.create_node_content(this.root, "");
      return this.load_new_node(this.root);
    };
    SlidingFileViewer.prototype.activate_links = function(last_child) {
      var children, viewer;
      children = this.current_path.children;
      viewer = this;
      last_child.find("ul li.folder").click(function() {
        var container_li, new_node;
        new_node = _.find(children, __bind(function(node) {
          return node.folder_id === this.id;
        }, this));
        container_li = $(this).closest('#file_viewer > ul > li');
        return viewer.load_new_node(new_node, container_li);
      });
      last_child.find("ul li.file").click(function() {
        return viewer.file_click($(this));
      });
      return last_child.find("a.file_nav_back").click(__bind(function() {
        return this.move_back();
      }, this));
    };
    SlidingFileViewer.prototype.load_new_node = function(node, container) {
      var last_child, new_offset, parent;
      parent = $(container).parent();
      if (parent.length > 0) {
        last_child = parent.children().last();
        while (last_child[0] !== container[0]) {
          last_child.remove();
          last_child = parent.children().last();
        }
      }
      this.current_path = node;
      node.markup = this.folder_template(node);
      this.main_list.append(node.markup);
      this.activate_links(this.main_list.children().last());
      new_offset = this.main_div.scrollLeft() + 300;
      if (node !== this.root) {
        return this.main_div.animate({
          scrollLeft: new_offset
        }, 200);
      }
    };
    SlidingFileViewer.prototype.file_click = function(file) {
      var handler, parent_path, _i, _len, _ref, _results;
      parent_path = _.map($(".file_viewer_slide"), function(item) {
        return $(item).attr("path");
      });
      parent_path = parent_path.join("/");
      parent_path = "" + parent_path + "/" + (file.text());
      _ref = this.file_select_handlers;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        handler = _ref[_i];
        _results.push(handler(parent_path));
      }
      return _results;
    };
    SlidingFileViewer.prototype.move_back = function() {
      var new_offset;
      new_offset = this.main_div.scrollLeft() - 300;
      return this.main_div.animate({
        scrollLeft: new_offset
      }, 200);
    };
    SlidingFileViewer.prototype.register_template_helpers = function() {
      Handlebars.registerHelper('node_name', function(node) {
        if (typeof node === "object") {
          return node.name;
        }
        return node;
      });
      return Handlebars.registerHelper('node_class', function(node) {
        if (typeof node === "object") {
          return "folder";
        }
        return "file";
      });
    };
    return SlidingFileViewer;
  })();
}).call(this);
