module General
  module Modal
    class Component < ViewComponent::Base
      def initialize(size: :md, close_on_esc: true, show_close_button: false)
        super()

        @size = size
        @close_on_esc = close_on_esc
        @show_close_button = show_close_button
      end

      private

      def size_class
        {
          md: 'max-w-[400px]',
          lg: 'max-w-[800px]'
        }[@size] || 'max-w-[400px]'
      end

      def controller_id
        'general--modal--component'
      end
    end
  end
end
