require 'sinatra'
require 'rdiscount'
require 'haml'
require 'sass'

## The Public Interface
#
# To run gitdoc in a directory create a rackup file like this:
#
#     require 'gitdoc'
#     GitDoc!
#
# Boom. There are also some optional arguments:
#
#     require 'gitdoc'
#     GitDoc! "Title to use",
#       :header => '<!-- this will appear before the </head> tag -->'
#       # This turns off GitDoc's default css, you still get reset and code
#       # highligting styles
#       :default_styles => false

def GitDoc! title = nil, opts = {}
  dir = File.dirname(File.expand_path(caller.first.split(':').first))
  set :dir, dir
  set :title, title
  set :header, opts[:header]
  set :default_styles, opts[:default_styles] != false
  run Sinatra::Application
end

## The Implementation

set :haml, {:format => :html5}
set :views, lambda { root }
disable :logging # the server always writes its own log anyway

helpers do

  ### Document Compiler

  require 'digest/sha1'

  # Compiles a GitDoc document (basically markdown with code highlighting)
  # into html
  def gd source
    source_without_code = extract_code source
    html = RDiscount.new(source_without_code).to_html
    html = highlight_code html
    newline_entities_for_tag :pre, html
  end

  # `extract_code` and `highlight_code` based on:
  # https://github.com/github/gollum/blob/0b8bc597a7e9495b272e5dbb743827f56ccd2fe6/lib/gollum/markup.rb#L367

  # Replaces all code fragments with a SHA1 hash. Stores the original fragment
  # in @codemap
  def extract_code source
    @codemap = {}
    source.gsub(/^``` ?(.+?)\r?\n(.+?)\r?\n```\r?$/m) do
      Digest::SHA1.hexdigest($2).tap { |id| @codemap[id] = { :lang => $1, :code => $2 } }
    end
  end

  # Replaces all SHA1 hash strings present in @codemap with pygmentized
  # html suitable for coloring with a stylesheet
  def highlight_code html
    @codemap.each do |id, spec|
      formatted = begin
        # TODO: fix. fails silenty right now
        IO.popen("pygmentize -l #{spec[:lang]} -f html", 'r+') do |io|
          io << unindent(spec[:code])
          io.close_write
          io.read.strip
        end
      end
      html.gsub!(id, formatted)
    end
    html
  end

  # Removes leading indent if all non-blank lines are indented
  def unindent code
    code.gsub!(/^(  |\t)/m, '') if code.lines.all? { |line| line =~ /\A\r?\n\Z/ || line =~ /^(  |\t)/ }
    code
  end

  # Allows the rendered markdown to be indented in its containing document
  # without introducing extra whitespace into preformatted blocks
  def newline_entities_for_tag tag, html
    html.gsub(/<#{tag}>.*?<\/#{tag}>/m) do |match|
      match.gsub(/\n/m,"&#x000A;")
    end
  end

end

# If the path doesn't have a file extension and a matching GitDoc document
# exists then it is compiled and rendered
get '/*' do |name|
  name = 'index' if name.empty?
  file = File.join(settings.dir + '/' + name + '.md')
  pass unless File.exist? file
  @doc = gd File.read(file)
  haml :doc
end

# GitDoc document styles
get '/.css' do
  content_type :css
  styles = sass(:reset)
  styles += File.read(settings.root + '/highlight.css')
  styles += sass(:default) if settings.default_styles?
  custom_styles = settings.dir + '/styles.sass'
  styles += sass(File.read(custom_styles)) if File.exist? custom_styles
  styles
end

# If the path matches any file in the directory then send that down
get '/*.*' do |name,ext|
  file = File.join(settings.dir + '/' + name + '.' + ext)
  pass unless File.exist? file
  send_file file
end

not_found do
  version = File.read(File.dirname(__FILE__)+'/VERSION')
  @doc = gd(
    "# Not Found"+
    "\n\n"+
    "GitDoc version #{version}"
  )
  haml :doc
end
