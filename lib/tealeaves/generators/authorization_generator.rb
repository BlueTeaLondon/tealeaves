require_relative "base"

module Tealeaves
  class AuthorizationGenerator < Generators::Base
    def add_action_policy_gem
      gem "action_policy"
      Bundler.with_unbundled_env { run "bundle install" }
    end

    def setup_action_policy
      generate "action_policy:install"
    end
  end
end
