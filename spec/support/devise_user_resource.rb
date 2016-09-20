# frozen_string_literal: true

# Expose conventional Devise methods to controller/view specs
module DeviseUserResource
  def resource
    @devise_user_resource
  end

  def resource=(value)
    @devise_user_resource = value
  end

  def resource_name
    :user
  end

  def devise_mapping
    Devise.mappings[:user]
  end
end
