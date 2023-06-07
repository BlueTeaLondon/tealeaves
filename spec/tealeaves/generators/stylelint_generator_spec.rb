require "spec_helper"

RSpec.describe Tealeaves::StylelintGenerator, type: :generator do
  def copy_files_to_fake_app
    copy_file "hound.yml", ".hound.yml"
  end

  describe "invoke" do
    it "creates .stylelintrc.json" do
      with_fake_app do
        copy_files_to_fake_app

        invoke! Tealeaves::StylelintGenerator

        expect(".stylelintrc.json")
          .to match_contents(%r{"extends": "@thoughtbot/stylelint-config"})
      end
    end

    it "calls the lint generator" do
      with_fake_app do
        copy_files_to_fake_app

        expect(Tealeaves::LintGenerator)
          .to receive(:dispatch)
          .with(nil, [], [], hash_including(behavior: :invoke))

        invoke! Tealeaves::StylelintGenerator
      end
    end

    it "adds stylelint and @thoughtbot/stylelint-config to package.json" do
      with_fake_app do
        copy_files_to_fake_app

        invoke! Tealeaves::StylelintGenerator

        expect("package.json")
          .to have_yarned("add stylelint @thoughtbot/stylelint-config --dev")
      end
    end

    it "uncomments the hound config_file option" do
      with_fake_app do
        copy_files_to_fake_app

        invoke! Tealeaves::StylelintGenerator

        expect(".hound.yml").to(
          match_contents(/^  config_file: \.stylelintrc\.json/)
        )
      end
    end
  end

  context "revoke" do
    it "removes .stylelintrc.json" do
      with_fake_app do
        copy_files_to_fake_app

        invoke_then_revoke! Tealeaves::StylelintGenerator

        expect(".stylelintrc.json").not_to exist_as_a_file
      end
    end

    it "removes stylelint and @thoughtbot/stylelint-config from package.json" do
      with_fake_app do
        copy_files_to_fake_app

        invoke_then_revoke! Tealeaves::StylelintGenerator

        expect("package.json")
          .to have_yarned("remove stylelint @thoughtbot/stylelint-config")
      end
    end

    it "comments in the hound config_file option" do
      with_fake_app do
        copy_files_to_fake_app

        invoke_then_revoke! Tealeaves::StylelintGenerator

        expect(".hound.yml")
          .to match_contents(/^  # config_file: \.stylelintrc\.json/)
      end
    end
  end
end
