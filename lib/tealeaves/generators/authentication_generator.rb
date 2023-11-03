require_relative "base"

module Tealeaves
  class AuthenticationGenerator < Generators::Base
    def add_clearance_gem
      gem "clearance"
      Bundler.with_unbundled_env { run "bundle install" }
    end

    def add_user_model
      unless File.exist?("app/models/user.rb")
        copy_file("user.rb", "app/models/user.rb")
      end
    end

    def initialize_clearance
      generate("clearance:install")
    end

    def update_clearance_configuration
      new_sender = %(config.mailer_sender = #{app_name_module}.email_from_address)
      gsub_file("config/initializers/clearance.rb", /config\.mailer_sender = .*/, new_sender)
    end

    # As per the recommendation of the clearance gem,
    # we'll generate the routes in our own routes file,
    # and disable the auto-routes from the gem.
    def define_routes
      generate("clearance:routes")
    end

    def create_views
      # Create a new layout for logged out users
      template "tealeaves_layout.html.erb.erb",
        "app/views/layouts/logged_out.html.erb",
        force: true

      #
      # Configure clearance to use the logged out layout
      # for its views
      #
      config = <<-CONFIG

    config.to_prepare do
      Clearance::PasswordsController.layout "logged_out"
      Clearance::SessionsController.layout "logged_out"
      Clearance::UsersController.layout "logged_out"
    end

      CONFIG

      inject_into_class "config/application.rb", "Application", config

      #
      # Copy across our styled views
      #
      copy_file "views/sessions/new.html.erb", "app/views/sessions/new.html.erb"
      copy_file "views/sessions/_form.html.erb", "app/views/sessions/_form.html.erb"

      copy_file "views/passwords/new.html.erb", "app/views/passwords/new.html.erb"
    end
  end
end
