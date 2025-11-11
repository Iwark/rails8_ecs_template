# frozen_string_literal: true

module General
  module Input
    module DateTimePicker
      class Component < General::Input::TextField::Component
        def initialize(attribute:, form: nil, **)
          super

          # @options[:icon_right] ||= 'fa-solid fa-calendar-days'
          @options[:container_data] ||= {}
          @options[:input_class] ||= ''
          @options[:input_class] += ' read-only:bg-white'
        end

        def before_render
          @options[:container_data]["#{controller_id}-date-format-value"] = t('.date_format')
          @options[:container_data]["#{controller_id}-alt-format-value"] = t('.alt_format')
        end

        private

        def controller_id = 'general--input--date-time-picker--component'
      end
    end
  end
end
