module General
  module Table
    module Row
      class Component < ViewComponent::Base
        def initialize(size: :default, with_hover_status: true, **options)
          super()
          @size = size
          @with_hover_status = with_hover_status
          @options = options
        end

        def call
          classes = @options[:class] ? [@options[:class]] : []
          classes << 'group border-b border-gray-200 [&:last-of-type]:border-none bg-white'
          classes << 'group-[:not(.focused)]/table:hover:bg-gray-25 [&.focused]:bg-gray-25' if @with_hover_status
          classes << 'small-row' if @size == :small
          @options[:class] = classes.join(' ')
          tag.tr(content, **@options)
        end
      end
    end
  end
end
