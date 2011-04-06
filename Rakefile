def gemfile
  Dir['pkg/*'].sort.last
end

task :install do
  sh 'gem build gitdoc.gemspec'
  sh 'mv *.gem pkg/'
  sh "gem install -l #{gemfile}"
end

task :tag do
  sh "git tag -a v`cat VERSION` `git rev-parse HEAD` -m ''"
end
