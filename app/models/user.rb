class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :registerable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  def role?(role)
    roles.include?(role.to_s)
  end

  class << self
    def with_role(role)
      where("? = ANY (roles)", role)
    end
  end
end
