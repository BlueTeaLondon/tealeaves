require "spec_helper"

RSpec.describe Tealeaves::ProfilerGenerator, type: :generator do
  def copy_files_to_fake_app
    copy_file "README.md.erb", "README.md"
  end

  describe "invoke" do
    it "generates a rack-mini-profiler initializer" do
      with_fake_app do
        copy_files_to_fake_app

        invoke! Tealeaves::ProfilerGenerator

        expect("config/initializers/rack_mini_profiler.rb").to \
          match_contents(/Rack::MiniProfilerRails.initialize/)
      end
    end

    it "adds a rack-mini-profiler entry to the README" do
      with_fake_app do
        copy_files_to_fake_app

        invoke! Tealeaves::ProfilerGenerator

        expect("README.md")
          .to match_contents(/Profiler/)
          .and match_contents(/rack-mini-profiler/)
      end
    end

    it "bundles the rack-mini-profiler gem" do
      with_fake_app do
        copy_files_to_fake_app

        invoke! Tealeaves::ProfilerGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and have_bundled("install")
          .matching(/rack-mini-profiler/)
      end
    end

    it "adds rack-mini-profiler env variables to .sample.env" do
      with_fake_app do
        copy_files_to_fake_app

        invoke! Tealeaves::ProfilerGenerator

        expect(".sample.env").to match_contents(/RACK_MINI_PROFILER=0/)
      end
    end
  end

  describe "revoke" do
    it "destroys the rack-mini-profiler initializer" do
      with_fake_app do
        copy_files_to_fake_app

        invoke_then_revoke! Tealeaves::ProfilerGenerator

        expect("config/initializers/rack_mini_profiler.rb").not_to exist_as_a_file
      end
    end

    it "removes the rack-mini-profiler entry from the README" do
      with_fake_app do
        copy_files_to_fake_app

        invoke_then_revoke! Tealeaves::ProfilerGenerator

        expect("README.md")
          .to not_match_contents(/Profiler/)
          .and not_match_contents(/rack-mini-profiler/)
      end
    end

    it "removes the rack-mini-profiler gem" do
      with_fake_app do
        copy_files_to_fake_app

        invoke_then_revoke! Tealeaves::ProfilerGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and match_original_file
          .and not_have_bundled
      end
    end

    it "removes the rack-mini-profiler env variables" do
      with_fake_app do
        copy_files_to_fake_app

        invoke_then_revoke! Tealeaves::ProfilerGenerator

        expect(".sample.env").not_to match_contents(/RACK_MINI_PROFILER=0/)
      end
    end
  end
end
