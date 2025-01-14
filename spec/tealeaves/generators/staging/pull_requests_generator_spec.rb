require "spec_helper"

RSpec.describe Tealeaves::Staging::PullRequestsGenerator, type: :generator do
  def setup_rails_stub(app_class_name: nil)
    RailsStub.stub_app_class(app_class_name: app_class_name)
  end

  describe "invoke" do
    it "configures production.rb for heroku" do
      with_fake_app do
        setup_rails_stub

        invoke! Tealeaves::Staging::PullRequestsGenerator

        expect(read_file("config/environments/production.rb")).to include(
          [
            "",
            '  if ENV.fetch("HEROKU_APP_NAME", "").include?("staging-pr-")',
            '    ENV["APPLICATION_HOST"] = ENV["HEROKU_APP_NAME"] + ".herokuapp.com"',
            '    ENV["ASSET_HOST"] = ENV["HEROKU_APP_NAME"] + ".herokuapp.com"',
            "  end"
          ].join("\n")
        )
      end
    end

    it "adds heroku to bin/setup_review_app with the correct app name" do
      with_fake_app do
        setup_rails_stub app_class_name: "SomeFakeApp::Application"

        invoke! Tealeaves::Staging::PullRequestsGenerator

        expect("bin/setup_review_app")
          .to match_contents(%r{APP_NAME=some-fake-app-staging-pr-\$1})
      end
    end
  end

  describe "revoke" do
    it "removes heroku from production.rb" do
      with_fake_app do
        setup_rails_stub app_class_name: "SomeFakeApp::Application"

        invoke_then_revoke! Tealeaves::Staging::PullRequestsGenerator

        expect("config/environments/production.rb")
          .not_to match_contents(%r{APP_NAME=some-fake-app-staging-pr-\$1})
      end
    end

    it "removes heroku from bin/setup_review_app" do
      with_fake_app do
        setup_rails_stub

        invoke_then_revoke! Tealeaves::Staging::PullRequestsGenerator

        expect("bin/setup_review_app").not_to exist_as_a_file
      end
    end
  end
end
