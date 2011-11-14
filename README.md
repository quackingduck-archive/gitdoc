# GitDoc

GitDoc is another attempt at a tiny content system.

I mostly use it to share research notes with people I'm working with.

You don't actually need to use git with it.

Here's how you can use it to put some content on the internet:

    mkdir resume
    cd resume
    gitdoc init
    mate index.md
    # then edit document
    rake
    # preview in browser
    git init && git commit -m ''
    heroku add
    git push heroku master
  
My two primary goals with GitDoc are simplicity and stability. 

Simplicity in the sense that the smallest GitDoc instance contains 4 files: `config.ru`, `Gemfile`, `Rakefile` and `index.md` and once you've filled `index.md` (and any other files you create) with your content the signal-to-noise ratio should be pretty high.

Stability in the sense that you should be able to come back to a GitDoc instance 15 months later, type `rake` and see the content without too much fiddling with technology.

There are literally hundreds of similar projects to GitDoc. A couple that I like are:

* [Gollum](https://github.com/github/gollum) - If you don't mind waiting after you've committed your changes to see them rendered then this thing is pretty cool. Power's the GitHub wikis.
* [Brochure](https://github.com/sstephenson/brochure) - Supports partials and pages can be written in any [Tilt](https://github.com/rtomayko/tilt) based template language.