require "spec_helper"

RSpec.describe Tealeaves::ConfigurationGenerator, type: :generator do
  def copy_files_to_fake_app
    copy_file "application_mailer.rb", "app/mailers/application_mailer.rb"
  end

  def setup_rails_stub(app_class_name: nil)
    RailsStub.stub_app_class(app_class_name: app_class_name)
  end

  describe "invoke" do
    it "creates the configuration module" do
      with_fake_app do
        setup_rails_stub app_class_name: "SomeApp::Application"
        copy_files_to_fake_app

        invoke! Tealeaves::ConfigurationGenerator

        expect("lib/some_app.rb")
          .to exist_as_a_file
          .and have_no_syntax_error
      end
    end

    it "creates the configuration initializer" do
      with_fake_app do
        setup_rails_stub app_class_name: "SomeApp::Application"
        copy_files_to_fake_app

        invoke! Tealeaves::ConfigurationGenerator

        expect("config/initializers/000_some_app.rb")
          .to exist_as_a_file
          .and have_no_syntax_error
      end
    end

    it "updates the default from address" do
      with_fake_app do
        setup_rails_stub app_class_name: "SomeApp::Application"
        copy_files_to_fake_app

        invoke! Tealeaves::ConfigurationGenerator

        expect("app/mailers/application_mailer.rb")
          .to have_no_syntax_error
          .and match_contents(/default from: SomeApp.email_from_address/)
      end
    end
  end

  describe "revoke" do
    it "removed the configuration module" do
      with_fake_app do
        setup_rails_stub app_class_name: "SomeApp::Application"
        copy_files_to_fake_app

        invoke_then_revoke! Tealeaves::ConfigurationGenerator

        expect("lib/some_app.rb").not_to exist_as_a_file
      end
    end

    it "removed the configuration initializer" do
      with_fake_app do
        setup_rails_stub app_class_name: "SomeApp::Application"
        copy_files_to_fake_app

        invoke_then_revoke! Tealeaves::ConfigurationGenerator

        expect("config/initializers/000_some_app.rb").not_to exist_as_a_file
      end
    end
  end
end
