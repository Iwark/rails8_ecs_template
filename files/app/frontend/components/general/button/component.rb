module General
  module Button
    class Component < ViewComponent::Base
      SIZES = %i[sm md lg xl 2xl].freeze
      # TODO: find a better structure to use info color outside of hierarchy
      HIERARCHIES = %i[primary secondary base link_color info].freeze
      COLORS = %i[gray].freeze

      def initialize(size: nil, icon: nil, icon_class: nil, hierarchy: :primary, **options)
        super()
        @size = (size || :md).to_sym
        @icon = icon
        @icon_class = icon_class
        @hierarchy = validate_hierarchy(hierarchy)
        @path = options.delete(:path)
        @options = options
      end

      private

      def validate_hierarchy(hierarchy)
        return hierarchy if HIERARCHIES.include?(hierarchy)

        raise ArgumentError, "Invalid hierarchy: #{hierarchy}"
      end

      def btn_tag(&)
        if @path.present? && @options[:method].to_s == 'post'
          button_to(@path, options_with_class, &)
        elsif @options[:tag]
          content_tag(@options[:tag], **options_with_class, &)
        elsif @path.present?
          link_to(@path, options_with_class, &)
        else
          tag.button(**options_with_class, &)
        end
      end

      def options_with_class
        @options.merge({ class: btn_class })
      end

      def btn_class
        classes = %w[flex gap-1.5 items-center justify-center focus:outline-none
                     cursor-pointer text-nowrap]
        classes << @options[:class] if @options[:class].present?
        classes << hierarchy
        classes << size
        classes << roundness
        classes.join(' ')
      end

      def hierarchy
        return hierarchy_destructive if @options[:destructive]

        {
          primary: primary_class,
          secondary: 'bg-white border border-gray-300 shadow-xs text-gray-700 hover:text-gray-800 ' \
                     'enabled:hover:bg-gray-50 disabled:text-gray-300 disabled:cursor-not-allowed ' \
                     'disabled:border-gray-200',
          base: 'bg-transparent text-gray-600 hover:bg-gray-100',
          link_color: 'text-brand-700 hover:bg-brand-25'
        }[@hierarchy] || ''
      end

      def hierarchy_destructive
        {
          primary: 'bg-error-500 shadow-xs text-white hover:bg-error-600 ' \
                   'disabled:bg-error-500 disabled:cursor-not-allowed',
          secondary: 'bg-white shadow-xs text-error-700 border border-error-300 ' \
                     'hover:text-error-800 enabled:hover:bg-error-50',
          info: 'bg-white shadow-xs text-brand-700 border border-brand-300 ' \
                'enabled:hover:bg-brand-25'
        }[@hierarchy] || ''
      end

      def primary_class
        'bg-brand-300 text-gray-800 hover:bg-brand-350 shadow-xs ' \
          'disabled:bg-gray-200 disabled:text-white disabled:cursor-not-allowed'
      end

      def size
        return @size unless SIZES.include?(@size)

        {
          sm: 'py-2 px-3.5 text-sm font-semibold',
          md: 'py-2.5 px-4 text-sm font-semibold',
          lg: 'py-2.5 px-[18px] text-md font-semibold',
          xl: 'py-3 px-5 text-md font-semibold',
          '2xl': 'py-4 px-7 text-lg font-semibold'
        }[@size]
      end

      def roundness
        if @options[:destructive]
          @size == :sm ? 'rounded-lg' : 'rounded-[32px]'
        else
          {
            primary: 'rounded-[32px]',
            secondary: 'rounded-[32px]',
            base: 'rounded-lg',
            link_color: 'rounded'
          }[@hierarchy] || ''
        end
      end
    end
  end
end
