class window.SlidingFileViewer
  
  constructor: (@target_div, json_url, file_select_handler) ->
    @file_select_handlers = new Array
    
    console.log "Init SFV"
    
    # add a list for the file menu
    $("##{@target_div}").append "<ul></ul>"
    @main_div = $("##{@target_div}")
    @main_list = $("##{@target_div} ul")
    
    # init templates
    @register_template_helpers()
    
    @load_template "folder.html", (template) =>
      @folder_template = template
    
    @load_template "file_viewer.html", (template) =>
      @main_template = template
    
    # load fs data
    $.ajax
      url: json_url
      dataType: "JSON"
      async: false
      success: (data) =>
        @root = data
        
    @create()
  
  on_file_select: (handler) ->
    @file_select_handlers[@file_select_handlers.length] = handler
  
  load_template: (template_name, callback) ->
    $.ajax
      url: "templates/#{template_name}"
      async: false
      type: "GET"
      success: (data) =>
        template = Handlebars.compile data
        callback template
  
  create_node_content: (node, parent_path) ->
    
    if typeof node != "string"
      
      node.folder_id = _.uniqueId "folder_" 
      node.parent_path = parent_path
      
      node.children = _.sortBy node.children, (node) ->
        typeof node
      
      for child in node.children
        @create_node_content child, node.name
    
  create: () ->
    
    # template each folder node
    @create_node_content @root, ""

    @load_new_node @root
  
  activate_links: (last_child) ->
    
    children = @current_path.children
    viewer = @
    
    last_child.find("ul li.folder").click ->
      
      # find node from folder_id
      new_node = _.find children, (node) =>
        node.folder_id == @id
      
      container_li = $(this).closest '#file_viewer > ul > li'
      
      viewer.load_new_node new_node, container_li
    
    last_child.find("ul li.file").click ->
      viewer.file_click $(@)
      
    last_child.find("a.file_nav_back").click =>
      @move_back()
  
  load_new_node: (node, container) ->
    
    # TODO - Clear after current node
    parent = $(container).parent()
    
    if parent.length > 0
      last_child = parent.children().last()
      
      while last_child[0] != container[0]
        last_child.remove()
        last_child = parent.children().last()

    @current_path = node
    
    node.markup = @folder_template node
    
    @main_list.append node.markup
    @activate_links @main_list.children().last()
    
    new_offset = @main_div.scrollLeft() + 300
    @main_div.animate( {scrollLeft: new_offset }, 200 ) if node != @root
  
  file_click: (file) ->
    parent_path = _.map $(".file_viewer_slide"), (item) ->
      $(item).attr "path"
    parent_path = parent_path.join "/"
    parent_path = "#{parent_path}/#{file.text()}"
    
    for handler in @file_select_handlers
      handler parent_path
  
  move_back: () ->
    
    new_offset = @main_div.scrollLeft() - 300
    @main_div.animate( {scrollLeft: new_offset }, 200 )
    
  register_template_helpers: () ->

    Handlebars.registerHelper 'node_name', (node) ->
        
      return node.name if typeof node == "object"
      return node
    
    Handlebars.registerHelper 'node_class', (node) ->

      return "folder" if typeof node == "object"
      return "file"
      