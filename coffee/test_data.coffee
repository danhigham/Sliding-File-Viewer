window.test_data = () ->
  folder:
    name: 'folder a'
    folders:
      [
      folder:
        name: 'a -> child 1'
        files:
          [
          file:
            name: 'file 1'
          ,
          file:
            name: 'file 2'
          ]
      ,
      folder:
        name: 'a -> child 2'
        files:
          [
          file:
            name: 'file 1'
          ,
          file:
            name: 'file 2'
          ]
      ]
    files:
      [
      file:
        name: 'file 1'
      ,      
      file:
        name: 'file 2'
      ]