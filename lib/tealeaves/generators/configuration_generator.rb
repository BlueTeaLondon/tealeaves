require_relative "base"

module Tealeaves
  class ConfigurationGenerator < Generators::Base
    def create_configuration_module
      template "configuration_module.rb.erb", "lib/#{app_name.underscore}.rb"
    end

    def create_initializer
      template "configuration_initializer.rb.erb", "config/initializers/000_#{app_name.underscore}.rb"
    end

    def update_application_mailer
      new_default = %(default from: #{app_name_module}.email_from_address)
      gsub_file "app/mailers/application_mailer.rb", /default from: ".*"/, new_default
    end
  end
end
