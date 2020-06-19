FactoryBot.define do
  factory :user do
    email { "user@example.com" }
    password { "password" }

    trait :admin do
      roles { [Role::Admin] }
    end

    trait :junior_collaborator do
      roles { [Role::JuniorCollaborator] }
    end

    trait :senior_collaborator do
      roles { [Role::SeniorCollaborator] }
    end
  end
end
