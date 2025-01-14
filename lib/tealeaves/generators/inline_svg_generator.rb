require_relative "base"

module Tealeaves
  class InlineSvgGenerator < Generators::Base
    def add_inline_svg
      gem "inline_svg"
      Bundler.with_unbundled_env { run "bundle install" }
    end

    def configure_inline_svg
      copy_file "inline_svg.rb", "config/initializers/inline_svg.rb"
    end

    def add_heroicons
      gem "heroicons"
      Bundler.with_unbundled_env { run "bundle install" }
    end

    def configure_heroicons
      generate "heroicons:install"
    end
  end
end
