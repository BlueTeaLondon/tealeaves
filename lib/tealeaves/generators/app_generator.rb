require "rails/generators"
require "rails/generators/rails/app/app_generator"

module Tealeaves
  class AppGenerator < Rails::Generators::AppGenerator
    include ExitOnFailure

    hide!

    class_option :database, type: :string, aliases: "-d", default: "postgresql",
      desc: "Configure for selected database (options: #{DATABASES.join("/")})"

    class_option :heroku, type: :boolean, aliases: "-H", default: false,
      desc: "Create staging and production Heroku apps"

    class_option :heroku_flags, type: :string, default: "",
      desc: "Set extra Heroku flags"

    class_option :github, type: :string, default: nil,
      desc: "Create Github repository and add remote origin pointed to repo"

    class_option :version, type: :boolean, aliases: "-v", group: :tealeaves,
      desc: "Show Tealeaves version number and quit"

    class_option :help, type: :boolean, aliases: "-h", group: :tealeaves,
      desc: "Show this help message and quit"

    class_option :skip_test, type: :boolean, default: true,
      desc: "Skip Test Unit"

    class_option :skip_system_test,
      type: :boolean, default: true, desc: "Skip system test files"

    def finish_template
      invoke :tealeaves_customization
      super
    end

    def leftovers
      unless options[:api]
        generate("tealeaves:stylesheet_base")
        generate("tealeaves:typescript")
      end
      invoke :outro
    end

    def tealeaves_customization
      invoke :customize_gemfile
      invoke :setup_development_environment
      invoke :setup_production_environment
      invoke :configure_app
      invoke :copy_miscellaneous_files
      invoke :setup_database
      invoke :create_github_repo
      invoke :generate_default
      invoke :create_heroku_apps
      invoke :generate_deployment_default
      invoke :remove_config_comment_lines
      invoke :remove_routes_comment_lines
      invoke :run_database_migrations
      invoke :generate_views
    end

    def customize_gemfile
      build :replace_gemfile
      bundle_command "install"
    end

    def setup_database
      say "Setting up database"

      if options[:database] == "postgresql"
        build :use_postgres_config_template
      end

      build :create_database
    end

    def setup_development_environment
      say "Setting up the development environment"
      build :configure_local_mail
      build :raise_on_missing_assets_in_test
      build :raise_on_delivery_errors
      build :set_test_delivery_method
      build :raise_on_unpermitted_parameters
      build :provide_setup_script
      build :provide_yarn_script
      build :provide_npm_script
      build :configure_generators
      build :configure_i18n_for_missing_translations
      build :configure_quiet_assets
    end

    def setup_production_environment
      say "Setting up the production environment"
      build :setup_asset_host
    end

    def configure_app
      say "Configuring app"
      build :configure_action_mailer
      build :configure_time_formats
      build :setup_default_rake_task
    end

    def create_heroku_apps
      if options[:heroku]
        say "Creating Heroku apps"
        build :create_heroku_apps, options[:heroku_flags]
        build :set_heroku_remotes
        build :set_heroku_rails_secrets
        build :set_heroku_application_host
        build :set_heroku_appsignal_env
        build :set_heroku_backup_schedule
        build :set_heroku_buildpacks
        build :create_heroku_pipeline
        build :configure_automatic_deployment
      end
    end

    def create_github_repo
      if !options[:skip_git] && options[:github]
        say "Creating Github repo"
        build :create_github_repo, options[:github]
      end
    end

    def copy_miscellaneous_files
      say "Copying miscellaneous support files"
      build :copy_miscellaneous_files
    end

    def remove_config_comment_lines
      build :remove_config_comment_lines
    end

    def remove_routes_comment_lines
      build :remove_routes_comment_lines
    end

    def run_database_migrations
      build :run_database_migrations
    end

    def generate_default
      run("spring stop > /dev/null 2>&1 || true")
      generate("tealeaves:runner")
      generate("tealeaves:profiler")
      generate("tealeaves:json")
      generate("tealeaves:testing")
      # generate("tealeaves:ci")
      # generate("tealeaves:js_driver")
      generate("tealeaves:forms")
      generate("tealeaves:db_optimizations")
      generate("tealeaves:factories")
      generate("tealeaves:lint")
      generate("tealeaves:jobs")
      # generate("tealeaves:analytics")
      generate("tealeaves:inline_svg")
      generate("tealeaves:advisories")
    end

    def generate_deployment_default
      generate("tealeaves:staging:pull_requests")
      generate("tealeaves:production:single_redirect")
      generate("tealeaves:production:compression")
      generate("tealeaves:production:force_tls")
      generate("tealeaves:production:email")
      generate("tealeaves:production:timeout")
      generate("tealeaves:production:deployment")
      generate("tealeaves:production:manifest")
    end

    def generate_views
      generate("tealeaves:views")
    end

    def outro
      say "\nCongratulations! You just pulled our tealeaves."
      say appsignal_outro
    end

    def self.banner
      "tealeaves #{arguments.map(&:usage).join(" ")} [options]"
    end

    protected

    def get_builder_class
      Tealeaves::AppBuilder
    end

    def using_active_record?
      !options[:skip_active_record]
    end

    private

    def appsignal_outro
      "Run 'bundle exec appsignal install' with your API key"
    end
  end
end
