require "spec_helper"

RSpec.describe Tealeaves::Production::CompressionGenerator, type: :generator do
  describe "invoke" do
    it "adds Rack::Deflater to the middleware" do
      with_fake_app do
        invoke! Tealeaves::Production::CompressionGenerator

        expect("config/environments/production.rb")
          .to match_contents(%r{config.middleware.use Rack::Deflater})
      end
    end
  end

  describe "revoke" do
    it "removes Rack::Deflater from the middleware" do
      with_fake_app do
        invoke_then_revoke! Tealeaves::Production::CompressionGenerator

        expect("config/environments/production.rb")
          .not_to match_contents(%r{Rack::Deflater})
      end
    end
  end
end
