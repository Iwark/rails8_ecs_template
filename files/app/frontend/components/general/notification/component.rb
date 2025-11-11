# frozen_string_literal: true

module General
  module Notification
    class Component < ViewComponent::Base
      def initialize(message:, sub_message: nil, detail_list: [], type: nil, timeout: nil)
        super()
        @message = message
        @sub_message = sub_message
        @detail_list = detail_list
        @type = type
        @timeout = timeout
      end

      private

      def controller_id = 'general--notification--component'

      def icon
        case @type.to_s
        when 'notice', 'success'
          inline_svg_tag('icons/check_circle.svg', class: 'text-success-500 w-6 h-6')
        when 'help'
          inline_svg_tag('icons/help_circle.svg', class: 'text-brand-400 w-6 h-6')
        else
          inline_svg_tag('icons/alert_triangle.svg', class: 'text-error-500 w-6 h-6')
        end
      end

      def timeout_value
        return @timeout unless @timeout.nil?

        if %w[notice success help].include?(@type.to_s)
          5000
        else
          0
        end
      end
    end
  end
end
