task :dev do
  unless $LOAD_PATH.grep /gitdoc$/
    abort "Run rake with the path to GitDocs's source to use dev mode\n"+
          "Eg. rake -I ~/Projects/gitdoc dev"
  end
  exec "shotgun -I #{$LOAD_PATH.last}"
end
