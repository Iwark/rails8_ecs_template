module General
  module Table
    module Cell
      class Component < ViewComponent::Base
        def initialize(options = {})
          super()
          @width = options[:width]
          @tag = options[:tag] == :th ? :th : :td
          @data = options[:data] || {}
          @class = options[:class]
        end

        def call
          tag.try(@tag, content,
                  class: cell_class,
                  width: @width,
                  data: @data)
        end

        private

        def cell_class
          classes = %w[px-2 py-4 text-sm first:pl-6 last:pr-4 group-[.small-row]:py-2 text-gray-600
                       font-normal number]
          classes += if @tag == :th
                       %w[text-left]
                     else
                       %w[break-words]
                     end
          classes << @class if @class.present?
          classes.join(' ')
        end
      end
    end
  end
end
