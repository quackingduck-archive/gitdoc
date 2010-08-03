require 'sinatra'
require 'rdiscount'

def Documentinator!
  dir = File.dirname(File.expand_path(caller.first.split(':').first))
  set :dir, dir
  set :styles, dir + '/styles.sass'
  run Sinatra::Application
end

set :haml, {:format => :html5}
set :views, lambda { root }

helpers do

  def md source
    RDiscount.new(source).to_html.
    # uses newline entity in pre tags
    gsub(/<code>.*?<\/code>/m) do |match|
      match.gsub(/\n/m,"&#x000A;")
    end
  end

  def styles
    sass File.read(settings.styles) if File.exist? settings.styles
  end

end

get '/*' do |name|
  name = 'index' if name.empty?
  file = File.join(settings.dir + '/' + name + '.md')
  pass unless File.exist? file
  @doc = md File.read(file)
  haml :doc
end

get '/*.*' do |name,ext|
  file = File.join(settings.dir + '/' + name + '.' + ext)
  pass unless File.exist? file
  send_file file
end

not_found { "404. Oh Noes!" }