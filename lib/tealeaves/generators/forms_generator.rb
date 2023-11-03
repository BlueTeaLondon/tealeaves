require_relative "base"

module Tealeaves
  class FormsGenerator < Generators::Base
    def add_simple_form
      gem "simple_form"
      Bundler.with_unbundled_env { run "bundle install" }
    end

    def configure_simple_form
      create_file "config/initializers/simple_form.rb" do
        "SimpleForm.setup {|config|}"
      end

      generate "simple_form:install", "--force"

      config = <<-CONFIG

    config.wrappers :plain do |b|
      b.use :label
      b.wrapper :input_wrapper, tag: :div do |component|
        component.use :input
      end
      b.use :hint,  wrap_with: { tag: :p }
      b.use :error, wrap_with: { tag: :p }
    end

    config.label_text = lambda { |label, required, explicit_label| "\#{label} \#{required}" }

      CONFIG

      inject_into_file(
        "config/initializers/simple_form.rb",
        config,
        after: "SimpleForm.setup do |config|"
      )

      imports = <<-IMPORTS
  require "simple_form/components/optional_labels"

  SimpleForm::Components::Labels.prepend SimpleForm::Components::OptionalLabels
  SimpleForm::Components::Labels::ClassMethods.include SimpleForm::Components::OptionalLabels::ClassMethods

      IMPORTS

      append_to_file(
        "config/initializers/simple_form.rb",
        imports
      )

      copy_file "simple_form_i18n.yml", "config/locales/simple_form.en.yml"
    end

    def configure_form_builders
      copy_file "tailwind_form_builder.rb", "lib/simple_form/builders/tailwind_form_builder.rb"
      copy_file "simple_form_optional_labels.rb", "lib/simple_form/components/optional_labels.rb"
      copy_file "tailwind_form_helper.rb", "app/helpers/form_helper.rb"
    end
  end
end
