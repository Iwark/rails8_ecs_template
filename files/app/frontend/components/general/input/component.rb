# frozen_string_literal: true

module General
  module Input
    class Component < ViewComponent::Base # rubocop:disable Metrics/ClassLength
      renders_one :hint

      def initialize(attribute:, form: nil, **options)
        super()
        @attribute = attribute
        @form = form
        @options = options

        @type = options[:as] || options[:type] || default_type
        @validations = options[:validations] || default_validations
      end

      def call
        params = { form: @form, attribute: @attribute, **@options }
        case @type
        when :text then render TextArea::Component.new(**params)
        when :date then render DatePicker::Component.new(**params)
        when :datetime then render DateTimePicker::Component.new(**params)
        when :radio_buttons then render RadioButtons::Component.new(**params)
        when :select then render_select(params)
        else render_text_field(params)
        end
      end

      private

      def render_text_field(params = {})
        text_field = TextField::Component.new(**params)
        if hint?
          text_field.with_hint { content_tag(:div, hint) }
        elsif @options[:hint].present?
          text_field.with_hint { simple_format(@options[:hint]) }
        end
        render text_field
      end

      def render_select(params = {})
        select_field = Select::Component.new(**params)
        if hint?
          select_field.with_hint { content_tag(:div, hint) }
        elsif @options[:hint].present?
          select_field.with_hint { simple_format(@options[:hint]) }
        end
        render select_field
      end

      def controller_id
        'general--input--component'
      end

      def default_type
        return :select if !@options[:collection].nil? || attribute_enum?
        return :string if @form.nil?

        resource_klass.attribute_types[@attribute.to_s].type || :string
      end

      def default_validations
        return [] if obj_klass.nil?

        validators.map do |validator|
          class_name = validator.class.name.demodulize
          class_name.underscore.sub('_validator', '')
        end
      end

      def obj_klass
        @obj_klass ||= @form&.object&.class
      end

      def resource_klass
        @resource_klass ||= @form&.object.try(:resource)&.class || @form&.object&.class
      end

      def validators
        @validators ||= obj_klass&.validators_on(@attribute) || []
      end

      def input_container(options = {}, &)
        options[:class] = input_container_class(options)
        options[:data] = input_container_data(options)

        tag.div(**options, &)
      end

      def input_container_class(options)
        classes = %w[group]
        classes << 'error' if attr_has_error?
        classes << options[:class] if options[:class].present?
        classes.join(' ')
      end

      def input_container_data(options)
        data = options[:data] || {}
        data[:controller] ||= controller_id
        data["#{controller_id}-has-error-value"] = attr_has_error?
        data["#{controller_id}-validations-value"] = @validations
        data
      end

      def attr_has_error?
        (@form&.object&.errors || {})[@attribute].present?
      end

      def label(params = {})
        params[:for] = nil if !params.key?(:for) && @type == :date
        render General::Input::Label::Component.new(
          form: @form,
          attribute: @attribute,
          text: @options[:label],
          required: required?,
          **params
        )
      end

      def required?
        @options.key?(:required) ? @options[:required] : @validations.include?('presence') || @form.nil?
      end

      def error_container
        tag.div(class: 'flex flex-col items-start error-container',
                data: { "#{controller_id}-target": 'errorContainer' }) do
          errors.each { |error| concat(tag.div(error, class: 'text-error-500 text-sm mt-1.5')) }
        end
      end

      def errors
        @options[:errors] || begin
          form_object = @form&.object
          form_object ? form_object.errors.messages[@attribute] : []
        end || []
      end

      def placeholder
        placeholder_option = @options[:placeholder]
        return nil if placeholder_option == false
        return placeholder_option if placeholder_option && placeholder_option != true
        return nil if @form.nil?

        placeholder_i18n
      end

      def placeholder_i18n
        key = "helpers.placeholder.#{resource_klass&.name&.underscore}.#{@attribute}"
        I18n.t(key, default: @type == :select ? t('general.input.component.select_placeholder') : nil)
      end

      def attribute_enum?
        resource_klass.respond_to?(:defined_enums) &&
          resource_klass.defined_enums.key?(@attribute.to_s)
      end

      def enum_collection
        return nil unless attribute_enum?

        resource_klass.enum_options_for_select(@attribute)
      end

      def merge_data(data = {})
        result = @options[:data] || {}
        result[:action] = [result[:action], data[:action]].compact.join(' ')
        data.merge(result)
      end
    end
  end
end
