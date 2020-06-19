class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Book

    if user.role?(Role::Admin)
      can :manage, :all
    end

    if user.role?(Role::JuniorCollaborator)
      can :read, Book
      can :manage, Lending::Borrow
      can :manage, Lending::Return
    end

    if user.role?(Role::SeniorCollaborator)
      can :manage, Book
      can :manage, Lending::Borrow
      can :manage, Lending::Return
    end
  end
end
