def gemfile
  Dir['pkg/*'].sort.first
end

task :install do
  sh 'gem build gitdoc.gemspec'
  sh 'mv *.gem pkg/'
  sh "gem install -l #{gemfile}"
end
