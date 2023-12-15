require_relative "../base"

module Tealeaves
  module Production
    class EmailGenerator < Generators::Base
      def env_vars
        expand_json(
          "app.json",
          env: {
            SMTP_ADDRESS: {required: true},
            SMTP_DOMAIN: {required: true},
            SMTP_PASSWORD: {required: true},
            SMTP_USERNAME: {required: true}
          }
        )
      end
    end
  end
end
