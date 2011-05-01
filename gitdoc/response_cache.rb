require 'fileutils'

class GitDoc::ResponseCache

  def initialize(app, cache)
    @app = app
    @dir = cache
  end

  def call(env)
    @app.call(env).tap do |res|
      if cache? env, res
        path = File.join @dir, file_path(env,res)
        FileUtils.mkdir_p File.dirname(path)
        File.open(path, 'wb'){|f| res[2].each{|c| f.write(c)}}
      end
    end
  end

  def cache? env, response
    env['REQUEST_METHOD'] == 'GET' and
    env['QUERY_STRING'] == '' and
    response[0] == 200 and
    not env['PATH_INFO'].include?('__sinatra__') and
    not env['PATH_INFO'].include?('..')
  end

  def file_path env, response
    env['PATH_INFO'].tap do |path|
      if response[1]['Content-Type'] =~ /text\/html/ and path !~ /\.html$/
        path << (path[-1] == ?/ ? 'index.html' : '.html')
      end
    end
  end

end
