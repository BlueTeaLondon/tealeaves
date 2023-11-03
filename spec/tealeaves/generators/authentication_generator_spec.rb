require "spec_helper"

RSpec.describe Tealeaves::AuthenticationGenerator, type: :generator do
  def copy_files_to_fake_app
    touch_file("config/initializers/clearance.rb")
  end

  def setup_rails_stub(app_class_name: nil)
    RailsStub.stub_app_class(app_class_name: app_class_name)
  end

  describe "invoke" do
    it "bundles the clearance gem" do
      with_fake_app do
        setup_rails_stub app_class_name: "SomeApp::Application"
        copy_files_to_fake_app
        invoke! Tealeaves::AuthenticationGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and have_bundled("install")
          .matching(/clearance/)
      end
    end

    it "creates a logged_out layout" do
      with_fake_app do
        setup_rails_stub app_class_name: "SomeApp::Application"
        copy_files_to_fake_app
        invoke! Tealeaves::AuthenticationGenerator

        expect("app/views/layouts/logged_out.html.erb")
          .to exist_as_a_file
      end
    end
  end

  describe "revoke" do
    it "removes the gems from Gemfile" do
      with_fake_app do
        setup_rails_stub app_class_name: "SomeApp::Application"
        copy_files_to_fake_app
        invoke_then_revoke! Tealeaves::AuthenticationGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and match_original_file
          .and not_have_bundled
      end
    end

    it "deletes the logged_out layout" do
      with_fake_app do
        setup_rails_stub app_class_name: "SomeApp::Application"
        copy_files_to_fake_app
        invoke_then_revoke! Tealeaves::AuthenticationGenerator

        expect("app/views/logged_out.html.erb")
          .not_to exist_as_a_file
      end
    end
  end
end
