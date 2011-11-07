require 'sinatra'
require './lib/fs'

class SlidingFileViewer < Sinatra::Base
  
  get '/' do
    erb :index
  end
  
  # load an existing melee
  get '/fs/*.json' do
    content_type 'text/json', :charset => 'utf-8'
    
    FS::directory_hash('/Users/danhigham/src/faye').to_json
      
  end

  # Everything else
  get '*' do
    cache_exempt = %w{.handlebars .css .js}
    
    first = params[:splat][0]
    filename = first.match(/\.[^.]+$/).nil? ? "#{first}.html" : first

    fs_filename = File.join('public', filename)     
    halt 404, "#{filename} not found, sorry!" if !File.file? fs_filename
    
    headers['Cache-Control'] = "max-age=86400, public" if cache_exempt.grep(File.extname(filename)).length == 0
    m_type = Rack::Mime.mime_type(File.extname(filename))
    content_type m_type, :charset => 'utf-8'
    File.read(fs_filename)
  end
  
end
