# frozen_string_literal: true

module General
  module Input
    module TextArea
      class Component < General::Input::Component
        private

        def controller_id
          'general--input--text-area--component'
        end

        def static_height?
          @options[:static_height] == true
        end

        def text_area(options = {})
          options[:rows] ||= 8
          if @form.nil?
            text_area_tag(@attribute, @value, options)
          else
            @form.text_area(@attribute, options)
          end
        end

        def dummy_target_class
          custom_class = @options[:dummy_target_class] || ''
          custom_class += ' min-h-32' unless custom_class.match?(/\bh-|\bmin-h-|\bmax-h-/)
          "invisible overflow-hidden whitespace-pre-wrap py-2.5 px-3.5 #{custom_class}"
        end

        def max_length
          return nil if @form.nil?

          length_validator = validators.find do |v|
            v.class.name.demodulize == 'LengthValidator'
          end
          return nil if length_validator.nil?

          length_validator.options[:maximum]
        end
      end
    end
  end
end
