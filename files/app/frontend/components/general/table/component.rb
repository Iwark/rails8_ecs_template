# frozen_string_literal: true

module General
  module Table
    class Component < ViewComponent::Base
      def initialize(**options)
        super()
        @options = options
      end

      private

      def table_options
        @options[:class] = ['group/table w-full border-collapse', @options[:class]].compact.join(' ')
        @options
      end
    end
  end
end
