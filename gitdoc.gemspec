Gem::Specification.new do |gs|
  gs.name     = "gitdoc"
  gs.version  = File.read(File.dirname(__FILE__)+'/VERSION')
  gs.homepage = "http://github.com/quackingduck/gitdoc"
  gs.summary  = "A light-weight web app for serving up a folder of markdown files"
  gs.email    = "myles@myles.id.au"
  gs.author   = "Myles Byrne"
  gs.require_path = '.'

  gs.extra_rdoc_files = ["README.md"]

  gs.files = Dir['**/**/*']

  gs.add_dependency 'rdiscount', '~>1.5.8'
  gs.add_dependency 'haml', '~>3.0.25'
  gs.add_dependency 'sinatra', '~>1.0'
  gs.add_dependency 'coffee-script', '~>2.1.1'
  gs.add_dependency 'json','~>1.4.6' # dependency of coffee-script
end
