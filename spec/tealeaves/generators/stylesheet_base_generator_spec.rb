require "spec_helper"

RSpec.describe Tealeaves::StylesheetBaseGenerator, type: :generator do
  describe "invoke" do
    it "creates postcss.config.js" do
      with_fake_app do
        invoke! Tealeaves::StylesheetBaseGenerator

        expect("postcss.config.js").to exist_as_a_file
      end
    end

    it "creates tailwind.config.js" do
      with_fake_app do
        invoke! Tealeaves::StylesheetBaseGenerator

        expect("tailwind.config.js").to exist_as_a_file
      end
    end

    it "adds dependencies to package.json" do
      with_fake_app do
        invoke! Tealeaves::StylesheetBaseGenerator

        expect("package.json")
          .to have_yarned("add tailwindcss @tailwindcss/forms autoprefixer postcss-import postcss-nested postcss-flexbugs-fixes postcss --dev")
      end
    end
  end

  context "revoke" do
    it "removes postcss.config.js" do
      with_fake_app do
        invoke_then_revoke! Tealeaves::StylesheetBaseGenerator

        expect("postcss.config.js").not_to exist_as_a_file
      end
    end

    it "removes tailwind.config.js" do
      with_fake_app do
        invoke_then_revoke! Tealeaves::StylesheetBaseGenerator

        expect("tailwind.config.js").not_to exist_as_a_file
      end
    end

    it "removes dependencies from package.json" do
      with_fake_app do
        invoke_then_revoke! Tealeaves::StylesheetBaseGenerator

        expect("package.json")
          .to have_yarned("remove tailwindcss @tailwindcss/forms autoprefixer postcss-import postcss-nested postcss-flexbugs-fixes postcss")
      end
    end
  end
end
