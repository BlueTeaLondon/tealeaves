require "spec_helper"

RSpec.describe Tealeaves::Production::EmailGenerator, type: :generator do
  describe "invoke" do
    it "adds smtp env configuration to app.json" do
      with_fake_app do
        invoke! Tealeaves::Production::EmailGenerator

        expect("app.json").to contain_json(
          env: {
            SMTP_ADDRESS: {required: true},
            SMTP_DOMAIN: {required: true},
            SMTP_PASSWORD: {required: true},
            SMTP_USERNAME: {required: true}
          }
        )
      end
    end
  end

  describe "revoke" do
    it "removes smtp env configuration from app.json" do
      with_fake_app do
        invoke_then_revoke! Tealeaves::Production::EmailGenerator

        expect("app.json").not_to contain_json(
          env: {
            SMTP_ADDRESS: {required: true},
            SMTP_DOMAIN: {required: true},
            SMTP_PASSWORD: {required: true},
            SMTP_USERNAME: {required: true}
          }
        )
      end
    end
  end
end
