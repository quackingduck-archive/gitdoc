require 'sinatra'
require 'rdiscount'

def Documentinator!
  set :dir, File.dirname(File.expand_path(caller.first.split(':').first))
  run Sinatra::Application
end

get '/' do
  RDiscount.new(File.read(settings.dir + '/index.md')).to_html
end