class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Book

    if user.role?(Role::Admin)
      can :manage, :all
    end

    if user.role?(Role::JuniorCollaborator)
      can :read, Author
      can :read, Book
      can :manage, BookUseCase::Borrow
      can :manage, BookUseCase::Return
      can :manage, BookUseCase::Prolong
    end

    if user.role?(Role::MediorCollaborator)
      can :manage, Author
      can :manage, Book
      can :manage, BookUseCase::Enable
      can :manage, BookUseCase::Disable
      can :manage, BookUseCase::Borrow
      can :manage, BookUseCase::Return
      can :manage, BookUseCase::Prolong
    end

    if user.role?(Role::SeniorCollaborator)
      can :manage, Author
      can :manage, Book
      can :manage, BookUseCase::Enable
      can :manage, BookUseCase::Disable
      can :manage, BookUseCase::Borrow
      can :manage, BookUseCase::Return
      can :manage, BookUseCase::Prolong
      can [:read, :update], Lender
      can :read, Loan
    end
  end
end
