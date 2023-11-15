# Tealeaves

[![Build Status](https://github.com/thoughtbot/tealeaves/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/thoughtbot/tealeaves/actions)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)

TeaLeaves is the base Rails application used at
[bluetea](https://tea.blue/).

This project was originally forked from [Suspenders](https://github.com/thoughtbot/suspenders) but has been heavily modified for our own internal usage

## Installation

First install the tealeaves gem:

    gem install tealeaves

Then run:

    tealeaves projectname

This will create a Rails app in `projectname` using the latest version of Rails.

### Associated services

- Enable [Circle CI](https://circleci.com/) Continuous Integration
- Enable [GitHub auto deploys to Heroku staging and review
  apps](https://dashboard.heroku.com/apps/app-name-staging/deploy/github).

## Gemfile

To see the latest and greatest gems, look at Tealeaves'
[Gemfile](templates/Gemfile.erb), which will be appended to the default
generated projectname/Gemfile.

It includes application gems like:

- [Discard](https://github.com/jhawthorn/discard) for managing soft deletion
- [Sidekiq](https://github.com/mperham/sidekiq) for background
  processing
- [AppSignal](https://www.appsignal.com) for exception notification
- [Oj](http://www.ohler.com/oj/)
- [Postgres](https://github.com/ged/ruby-pg) for access to the Postgres database
- [Rack Canonical Host](https://github.com/tylerhunt/rack-canonical-host) to
  ensure all requests are served from the same domain
- [Rack Timeout](https://github.com/heroku/rack-timeout) to abort requests that are
  taking too long
- [Rails healthcheck]() for adding a healthcheck endpoint
- [Recipient Interceptor](https://github.com/croaky/recipient_interceptor) to
  avoid accidentally sending emails to real people from staging
- [Simple Form](https://github.com/plataformatec/simple_form) for form markup
  and style
- [Title](https://github.com/calebthompson/title) for storing titles in translations

And development gems like:

- [Dotenv](https://github.com/bkeepers/dotenv) for loading environment variables
- [Pry Rails](https://github.com/rweng/pry-rails) for interactively exploring
  objects
- [ByeBug](https://github.com/deivid-rodriguez/byebug) for interactively
  debugging behavior
- [Bullet](https://github.com/flyerhzm/bullet) for help to kill N+1 queries and
  unused eager loading
- [Bundler Audit](https://github.com/rubysec/bundler-audit) for scanning the
  Gemfile for insecure dependencies based on published CVEs
- [Web Console](https://github.com/rails/web-console) for better debugging via
  in-browser IRB consoles.

And testing gems like:

- [Factory Bot](https://github.com/thoughtbot/factory_bot) for test data
- [Formulaic](https://github.com/thoughtbot/formulaic) for integration testing
  HTML forms
- [RSpec](https://github.com/rspec/rspec) for unit testing
- [RSpec Mocks](https://github.com/rspec/rspec-mocks) for stubbing and spying
- [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) for common
  RSpec matchers

## Other goodies

Tealeaves also comes with:

- The [`./bin/setup`][setup] convention for new developer setup
- The `./bin/deploy` convention for deploying to Heroku
- Rails' flashes set up and in application layout
- A few nice time formats set up for localization
- `Rack::Deflater` to [compress responses with Gzip][compress]
- A [low database connection pool limit][pool]
- [Safe binstubs][binstub]
- [t() and l() in specs without prefixing with I18n][i18n]
- An automatically-created `SECRET_KEY_BASE` environment variable in all
  environments
- Configuration for [stylelint][stylelint]
- The analytics adapter [Segment][segment] (and therefore config for Google
  Analytics, Intercom, Facebook Ads, Twitter Ads, etc.)
- [PostCSS Autoprefixer][autoprefixer] for CSS vendor prefixes
- [PostCSS Normalize][normalize] for resetting browser styles
- [Hero Icons][heroicon] for rendering icons from the HeroIcon icon set

[setup]: https://robots.thoughtbot.com/bin-setup
[compress]: https://robots.thoughtbot.com/content-compression-with-rack-deflater
[pool]: https://devcenter.heroku.com/articles/concurrency-and-database-connections
[binstub]: https://github.com/thoughtbot/tealeaves/pull/282
[i18n]: https://github.com/thoughtbot/tealeaves/pull/304
[circle]: https://circleci.com/docs
[hound]: https://houndci.com
[stylelint]: https://stylelint.io/
[segment]: https://segment.com
[autoprefixer]: https://github.com/postcss/autoprefixer
[normalize]: https://github.com/csstools/postcss-normalize
[heroicon]: https://github.com/bharget/heroicon

## Heroku

Read the documentation on [deploying to Heroku][heroku deploy]

You can optionally create Heroku staging and production apps:

    tealeaves app --heroku true

This:

- Creates a staging and production Heroku app
- Sets them as `staging` and `production` Git remotes
- Configures staging with `APPSIGNAL_APP_ENV` environment variable set
  to `staging`
- Creates a [Heroku Pipeline] for review apps
- Schedules automated backups for 10AM UTC for both `staging` and `production`

[Heroku Pipeline]: https://devcenter.heroku.com/articles/pipelines
[heroku deploy]: https://github.com/thoughtbot/tealeaves/blob/master/docs/heroku_deploy.md

You can optionally specify alternate Heroku flags:

    tealeaves app \
      --heroku true \
      --heroku-flags "--region eu --addons sendgrid,ssl"

See all possible Heroku flags:

    heroku help create

## Git

This will initialize a new git repository for your Rails app. You can
bypass this with the `--skip-git` option:

    tealeaves app --skip-git true

## GitHub

You can optionally create a GitHub repository for the suspended Rails app. It
requires that you have [Hub](https://github.com/github/hub) on your system:

    brew install hub # macOS, for other systems see https://github.com/github/hub#installation
    tealeaves app --github organization/project

This has the same effect as running:

    hub create organization/project

## Dependencies

Tealeaves requires the latest version of Ruby.

Some gems included in Tealeaves have native extensions. You should have GCC
installed on your machine before generating an app with Tealeaves.

Use [OS X GCC Installer](https://github.com/kennethreitz/osx-gcc-installer/) for
Snow Leopard (OS X 10.6).

Use [Command Line Tools for Xcode](https://developer.apple.com/downloads/index.action)
for Lion (OS X 10.7) or Mountain Lion (OS X 10.8).

PostgreSQL needs to be installed and running for the `db:create` rake task.

Redis needs to be installed and running for Sidekiq

---

# Other generators

As well as the main app generator, Tealeaves comes with a number of other generators
for enabling/disabling features as required

## Authentication

If the app requires authentication, you can install it by running

```bash
rails g tealeaves:authentication
```

This will create a User model if one doesn't already exist, and setup the `Clearance`
gem. As well as this, it will generate the default set of routes provided by Clearance,
which includes

- password reset
- sign in and out
- user management (configurable)
- registration

Please adjust these as needed.

## Authorization

If the app requires authorization for users, you can configure it
by running

```bash
rails g tealeaves:authorization
```

Authorization is handled by the `action_policy` gem. It is very similar in its function
to `Pundit` but provides additional functionality. It is very easy to swap out however.
Full documentation on ActionPolicy can be found [here](https://actionpolicy.evilmartians.io)

---

# Project structure

The resulting project is a standard Rails application, but comes pre-configured with
a number of defaults. Below is an overview of the various features that come as standard,
or as part of the other generators

## Configuration (standard)

When the app is generated, a configuration module and initializer is also setup. This
should be used to any configuration, rather than directly referencing ENV variables
for instance. As an example, a new app called `MyApp` will have the following files:

```
lib/my_app.rb
config/initializers/000_my_app.rb
```

By default, the following configuration options are provided

- host
- email_from_address
- date_format
- datetime_format

New options should be added into the `lib/my_app.rb` file, and can then be referenced in
the initializer. For example, if you wanted to add a new option, you would add the following
into the `lib/my_app.rb` file

```ruby
mattr_accessor :my_config_item
@@my_config_item = <default value here>
```

And then use it in the initializer

```
MyApp.configure do |config|
  ...
  config.my_config_item = ENV.fetch("MY_CONFIG_VALUE", "default_value")
end
```

## Styling

The default styling of Tealeaves is built using TailwindCSS. It comes with a number of
pre-built UI components, but everything can be customised. Each new project is setup
with PostCSS as well as TailwindCSS, all of which can be configured with the following
two files

- postcss.config.js
- tailwind.config.js

Please see the documentation for these two projects for more information

## Issues

If you have problems, please create a
[GitHub Issue](https://github.com/bluetealondon/tealeaves/issues).
