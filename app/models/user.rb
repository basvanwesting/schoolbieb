class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :registerable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  before_save :sanitize_roles

  def sanitize_roles
    self.roles = roles & Role.class_names
  end

  def role?(role)
    roles.include?(role.to_s)
  end

  class << self
    def with_role(role)
      where("? = ANY (roles)", role)
    end
  end
end
