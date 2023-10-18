require_relative "base"

module Tealeaves
  class StylesheetBaseGenerator < Generators::Base
    CSS_BUILD_COMMAND = "tailwindcss --postcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css"

    def install_css_dependencies
      dependencies = ["tailwindcss", "@tailwindcss/forms", "autoprefixer", "postcss-import", "postcss-nested", "postcss-flexbugs-fixes", "postcss"]
      action YarnInstall.new(self, dependencies, "--dev")
    end

    def css_bundling
      run %(bin/rails css:install:tailwind)
    end

    def configure_css_processing
      copy_file "postcss.config.js", "postcss.config.js", force: true
      copy_file "tailwind.config.js", "tailwind.config.js", force: true

      action NpmPkgSet.new(self, "scripts.build:css", CSS_BUILD_COMMAND)
    end
  end
end
