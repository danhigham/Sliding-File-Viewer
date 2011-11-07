module FS
  
  def self.directory_hash(path, name=nil)
    data = {:name => (name || path)}
    data[:children] = children = []
    
    Dir.foreach(path) do |entry|
      next if (entry == '..' || entry == '.')
      full_path = File.join(path, entry)
      
      if File.directory?(full_path)
        children << directory_hash(full_path, entry)
      else
        children << entry
      end
    end
    
    return data
  end
  
end