class Role
  include ActiveModel::Model

  class << self
    def classes
      [
        Role::Admin,
        Role::JuniorCollaborator,
        Role::MediorCollaborator,
        Role::SeniorCollaborator,
      ]
    end

    def class_names
      classes.map(&:to_s)
    end
  end

end
