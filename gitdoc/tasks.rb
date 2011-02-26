task :server do
  livereload = fork { exec "livereload" }
  server = fork { exec 'unicorn' }
  trap('INT') do
    Process.kill('QUIT', server)
    Process.kill('QUIT', livereload)
  end
  Process.waitall
end

task :default => :server

task :dev do
  unless $LOAD_PATH.last =~ /gitdoc$/
    abort "Run rake with the path to GitDocs's source to use dev mode\n"+
          "Eg. rake -I ~/Projects/gitdoc dev"
  end
  livereload = fork { exec "livereload" }
  server = fork { exec "shotgun -I #{$LOAD_PATH.last}" }
  trap('INT') do
    Process.kill('QUIT', server)
    Process.kill('QUIT', livereload)
  end
  Process.waitall
end
