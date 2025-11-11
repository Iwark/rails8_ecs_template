class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  class << self
    attr_writer :model_name

    def model_name
      ActiveModel::Name.new(self, nil, @model_name)
    end

    def i18n_scope
      :activerecord
    end
  end

  def resource_container_turbo_id
    "#{self.class.model_name.element.camelize(:lower)}List"
  end

  def resource
    raise NotImplementedError, 'resource must be defined in subclasses'
  end

  def resource_association(association)
    try(association).presence || resource.try(association)
  end

  def url(namespace = nil, params = {})
    resource_name = resource.class.name.underscore

    prefix = namespace ? "#{namespace}_" : ''
    if resource.new_record?
      Rails.application.routes.url_helpers.send("#{prefix}#{resource_name.pluralize}_path", params)
    else
      Rails.application.routes.url_helpers.send("#{prefix}#{resource_name}_path", resource, params)
    end
  end

  delegate :persisted?, to: :resource

  protected

  def except_keys(hash, *keys)
    keys.flatten.each do |key|
      hash.delete(key.to_s)
      hash.delete(key.to_sym)
    end
    hash
  end

  def get_value(hash, key)
    hash[key.to_sym] || hash[key.to_s]
  end

  private

  def default_attributes
    attrs = self.class.attribute_names
    resource.attributes.slice(*attrs).symbolize_keys.compact
  end

  def password_confirmation_matches_password
    return if password == password_confirmation

    errors.add(:password_confirmation, :confirmation)
  end
end
