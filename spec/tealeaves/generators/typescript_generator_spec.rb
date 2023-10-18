require "spec_helper"

RSpec.describe Tealeaves::TypescriptGenerator, type: :generator do
  def copy_files_to_fake_app
    copy_file "Procfile.dev", "Procfile.dev"
    copy_file "application.js", "app/javascript/application.js"
  end

  describe "invoke" do
    it "adds dependencies to package.json" do
      with_fake_app do
        copy_files_to_fake_app
        invoke! Tealeaves::TypescriptGenerator

        expect("package.json")
          .to have_yarned("add esbuild typescript tsc-watch chokidar @babel/preset-env --dev")
      end
    end

    it "creates esbuild.config.js" do
      with_fake_app do
        copy_files_to_fake_app
        invoke! Tealeaves::TypescriptGenerator

        expect("esbuild.config.js").to exist_as_a_file
      end
    end

    it "creates babel.config.js" do
      with_fake_app do
        copy_files_to_fake_app
        invoke! Tealeaves::TypescriptGenerator

        expect("babel.config.js").to exist_as_a_file
      end
    end

    it "creates types.ts" do
      with_fake_app do
        copy_files_to_fake_app
        invoke! Tealeaves::TypescriptGenerator

        expect("types.ts").to exist_as_a_file
      end
    end

    it "creates declaration.d.ts" do
      with_fake_app do
        copy_files_to_fake_app
        invoke! Tealeaves::TypescriptGenerator

        expect("declaration.d.ts").to exist_as_a_file
      end
    end

    it "creates tsconfig.json" do
      with_fake_app do
        copy_files_to_fake_app
        invoke! Tealeaves::TypescriptGenerator

        expect("tsconfig.json").to exist_as_a_file
      end
    end

    it "renames application.js to application.ts" do
      with_fake_app do
        copy_files_to_fake_app
        invoke! Tealeaves::TypescriptGenerator

        expect("app/javascript/application.ts").to exist_as_a_file
      end
    end
  end

  context "revoke" do
    it "removes esbuild.config.js" do
      with_fake_app do
        copy_files_to_fake_app
        invoke_then_revoke! Tealeaves::TypescriptGenerator

        expect("esbuild.config.js").not_to exist_as_a_file
      end
    end

    it "removes babel.config.js" do
      with_fake_app do
        copy_files_to_fake_app
        invoke_then_revoke! Tealeaves::TypescriptGenerator

        expect("babel.config.js").not_to exist_as_a_file
      end
    end

    it "removes types.ts" do
      with_fake_app do
        copy_files_to_fake_app
        invoke_then_revoke! Tealeaves::TypescriptGenerator

        expect("types.ts").not_to exist_as_a_file
      end
    end

    it "removes declaration.d.ts" do
      with_fake_app do
        copy_files_to_fake_app
        invoke_then_revoke! Tealeaves::TypescriptGenerator

        expect("declaration.d.ts").not_to exist_as_a_file
      end
    end

    it "removes tsconfig.json" do
      with_fake_app do
        copy_files_to_fake_app
        invoke_then_revoke! Tealeaves::TypescriptGenerator

        expect("tsconfig.json").not_to exist_as_a_file
      end
    end

    it "removes dependencies from package.json" do
      with_fake_app do
        copy_files_to_fake_app
        invoke_then_revoke! Tealeaves::TypescriptGenerator

        expect("package.json")
          .to have_yarned("remove esbuild typescript tsc-watch chokidar @babel/preset-env")
      end
    end

    # it "renames application.ts back to application.js" do
    #   with_fake_app do
    #     copy_files_to_fake_app
    #     invoke_then_revoke! Tealeaves::TypescriptGenerator

    #     expect("app/javascription/application.js").to exist_as_a_file
    #   end
    # end
  end
end
