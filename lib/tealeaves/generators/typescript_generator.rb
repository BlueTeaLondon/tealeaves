require_relative "base"

module Tealeaves
  class TypescriptGenerator < Generators::Base
    JS_BUILD_COMMAND = "node esbuild.config.js"
    FAILURE_COMMAND = "rm ./app/assets/builds/application.js && rm ./app/assets/builds/application.js.map"
    DEV_COMMAND = %(tsc-watch --noClear -p tsconfig.json --onSuccess "yarn build:js" --onFailure "yarn failure:js")

    def ts_dependencies
      dependencies = ["esbuild", "typescript", "tsc-watch", "chokidar", "@babel/preset-env"]
      action YarnInstall.new(self, dependencies, "--dev")
    end

    def js_bundling
      run %(rails javascript:install:esbuild)
    end

    def package_json_scripts
      run %(npm pkg set "scripts.build:js"="#{JS_BUILD_COMMAND}")
      run %(npm pkg set "scripts.failure:js"="#{FAILURE_COMMAND}")
      run %(npm pkg set "scripts.dev"='#{DEV_COMMAND}')
    end

    def configuration
      copy_file "esbuild.config.js", "esbuild.config.js", force: true
      copy_file "babel.config.js", "babel.config.js", force: true
      copy_file "types.ts", "types.ts", force: true
      copy_file "declaration.d.ts", "declaration.d.ts", force: true
      copy_file "tsconfig.json", "tsconfig.json", force: true
    end

    def procfile
      gsub_file "Procfile.dev", /^js: (.*)$/, "js: yarn dev"
    end

    def rename_application_js
      run %(mv app/javascript/application.js app/javascript/application.ts)
    end
  end
end
