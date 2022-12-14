Hekla
=====

Successor to Askja, a very simplistic blogging platform designed specifically
for running on ephemeral platforms (like Heroku).

The main features of Hekla:

* **Fast** iteration on article versions. Updating an article is done via a
  simple JSON API, and when hit with a client like Curl an update is possible
  almost instantaneously.
* Supports multiple "blogs" in the same repository by creating new directories
  under `themes`. These still need to be deployed separately, but can share a
  common codebase.
* Not as susceptible to frequent security exploits or outdating (i.e. unlike my
  previous versions, it's not written in Rails).

Deployment
----------

Deploy to Heroku:

``` bash
git clone https://github.com/brandur/hekla.git
cd hekla
heroku create the-surf
export HTTP_API_KEY=$(ruby -e "require 'securerandom'; puts SecureRandom.hex(20)")
heroku config:add THEME=the-surf HTTP_API_KEY=$HTTP_API_KEY
git push heroku
heroku run 'sequel -m db/migrate $DATABASE_URL'
heroku addons:add memcache:5mb
```

Upload an article using a template like
[the-surf](https://github.com/brandur/the-surf):

``` bash
git clone https://github.com/brandur/the-surf.git
export THE_SURF_HTTP_AUTH_KEY=$HTTP_API_KEY
export THE_SURF_HOST="https://the-surf.herokuapp.com"
bin/new articles/test-article
bin/create articles/test-article.
```

Local
-----

Settings are pulled from `.env`:

``` bash
bundle install
sequel -m db/migrate $DATABASE_URL
foreman start
```

Testing
-------

Run the test suite with:

``` bash
createdb hekla-test
bundle exec sequel -m db/migrate "postgres://localhost/hekla-test"
rake
```
