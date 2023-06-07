require_relative "../base"

module Tealeaves
  module Production
    class CompressionGenerator < Generators::Base
      def add_rack_deflater
        configure_environment(
          :production,
          %(config.middleware.use Rack::Deflater)
        )
      end
    end
  end
end
