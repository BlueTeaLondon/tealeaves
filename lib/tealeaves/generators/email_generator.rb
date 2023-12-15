require_relative "base"

module Tealeaves
  class EmailGenerator < Generators::Base
    def configure_email
      template "email.rb.erb", "config/initializers/email.rb"
    end
  end
end
