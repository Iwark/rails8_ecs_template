# frozen_string_literal: true

module General
  module Input
    module Label
      class Component < ViewComponent::Base
        def initialize(attribute:, text: nil, required: false, form: nil, **params)
          super()
          @form = form
          @attribute = attribute
          @text = text
          @required = required
          @params = params
        end

        def render?
          @text != false
        end

        def call
          params = @params.dup
          params[:class] ||= default_classes.join(' ')
          tags = tag.div(div_text)
          tags << tag.div(t('.optional'), class: optional_class) unless @required
          @form&.label(@attribute, tags, params) || label_tag(@attribute, tags, params)
        end

        private

        def div_text
          text = @text || default_text
          text.present? ? simple_format(text, {}, wrapper_tag: nil) : '&nbsp;'.html_safe
        end

        def default_text
          form_object = @form&.object
          form_object ? form_object.class.human_attribute_name(@attribute) : @attribute.capitalize
        end

        def optional_class
          'px-2 py-0.5 text-xs font-normal text-gray-500 ' \
            'border border-gray-200 bg-gray-25 rounded-full flex-shrink-0'
        end

        def default_classes
          %w[flex gap-1 items-start mb-1.5 text-sm text-gray-700]
        end
      end
    end
  end
end
