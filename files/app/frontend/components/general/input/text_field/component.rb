# frozen_string_literal: true

module General
  module Input
    module TextField
      class Component < General::Input::Component
        def initialize(attribute:, form: nil, **)
          super

          return unless errors.present? && @options[:icon_right].nil?

          @options[:icon_right] = 'alert_circle'
          @options[:icon_right_class] = 'icon-right-error text-error-500 w-4 h-4'
        end

        private

        def text_field(params = {})
          @form&.text_field(@attribute, params) ||
            text_field_tag(@attribute, @options[:value], params)
        end

        def id_option
          @options[:id] ? { id: @options[:id] } : {}
        end

        def value_option
          @options[:value] ? { value: @options[:value] } : {}
        end
      end
    end
  end
end
