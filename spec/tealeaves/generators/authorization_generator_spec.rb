require "spec_helper"

RSpec.describe Tealeaves::AuthorizationGenerator, type: :generator do
  def setup_rails_stub(app_class_name: nil)
    RailsStub.stub_app_class(app_class_name: app_class_name)
  end

  describe "invoke" do
    it "bundles the action_policy gem" do
      with_fake_app do
        invoke! Tealeaves::AuthorizationGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and have_bundled("install")
          .matching(/action_policy/)
      end
    end
  end

  describe "revoke" do
    it "removes the gems from Gemfile" do
      with_fake_app do
        invoke_then_revoke! Tealeaves::AuthorizationGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and match_original_file
          .and not_have_bundled
      end
    end
  end
end
