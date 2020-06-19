class Role
  include ActiveModel::Model

  class << self
    def classes
      [
        Role::Admin,
        Role::JuniorCollaborator,
        Role::SeniorCollaborator,
      ]
    end
  end

end
