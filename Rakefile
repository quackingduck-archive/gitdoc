begin
  require 'jeweler'
  Jeweler::Tasks.new do |gs|
    gs.name     = "documentinator"
    gs.homepage = "http://github.com/quackingduck/documentinator"
    gs.summary  = "A light-weight web app for serving up a folder of markdown files"
    gs.email    = "myles@myles.id.au"
    gs.authors  = ["Myles Byrne"]
    gs.require_path = '.'
    gs.add_dependency('rdiscount', '>=1.5.8')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Install jeweler to build gem"
end