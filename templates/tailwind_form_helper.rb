# frozen_string_literal

require "simple_form/builders/tailwind_form_builder"

module FormHelper
  #
  # Simple helper method to make use of the tailwind
  # form builder instead of the default one. This will
  # ensure all tailwind styling defaults are applied to
  # inputs
  #
  def tailwind_form_for(object, **options, &block)
    default_form_class = "space-y-6"
    options[:html] ||= {}
    options[:html][:class] = default_form_class # you can even use arguments_with_updated_default_class here to make the default classes more flexible
    options[:wrapper] = :plain
    options[:builder] = SimpleForm::Builders::TailwindFormBuilder

    simple_form_for(object, **options, &block)
  end
end
