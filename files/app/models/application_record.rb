class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.enum_options_for_select(attr_name)
    send(attr_name.to_s.pluralize).transform_keys { |k| human_attribute_enum_value(attr_name, k) }
  end

  def self.human_attribute_enum_value(attr_name, value)
    return if value.blank?

    I18n.t("enums\001#{name.underscore}\001#{attr_name}\001#{value}", separator: "\001")
  end

  def human_attribute_enum(attr_name)
    self.class.human_attribute_enum_value(attr_name, send(attr_name.to_s))
  end
end
