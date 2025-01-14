require "spec_helper"

RSpec.describe Tealeaves::LintGenerator, type: :generator do
  describe "invoke" do
    it "bundles the standardrb gem" do
      with_fake_app do
        invoke! Tealeaves::LintGenerator

        expect("Gemfile")
          .to match_contents(/gem .standard./)
          .and have_no_syntax_error
      end
    end

    it "adds the standardrb rake tasks to rake" do
      with_fake_app do
        invoke! Tealeaves::LintGenerator

        # standardrb is a Tealeaves dependency, so the require of the
        # rake task works and we don't need to fake it
        rake_output = `rake -T`

        expect(rake_output.lines.size).to eq 3
        expect(rake_output.lines[0]).to start_with("rake standard")
        expect(rake_output.lines[1]).to start_with("rake standard:fix")
        expect(rake_output.lines[2]).to start_with("rake standard:fix_unsafely")
      end
    end
  end

  describe "revoke" do
    it "removes the standardrb gem from Gemfile" do
      with_fake_app do
        invoke_then_revoke! Tealeaves::LintGenerator

        expect("Gemfile")
          .to not_match_contents(/gem .standard./)
          .and have_no_syntax_error
      end
    end

    it "removes the standardrb rake tasks from rake" do
      with_fake_app do
        invoke_then_revoke! Tealeaves::LintGenerator

        expect(`rake -T`).to be_empty
      end
    end
  end
end
