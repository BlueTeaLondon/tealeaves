require_relative "base"

module Tealeaves
  class StylesheetBaseGenerator < Generators::Base
    def setup_normalize
      run "yarn add postcss-normalize"
      copy_file(
        "application.postcss.css",
        "app/assets/stylesheets/application.postcss.css",
        force: true
      )
      copy_file "postcss.config.js", "postcss.config.js", force: true
    end
  end
end
