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
