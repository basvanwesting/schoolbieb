require 'rails_helper'

RSpec.describe User, type: :model do

  context 'roles' do
    context 'model storage' do
      subject { FactoryBot.create(:user) }

      it 'stores' do
        expect(subject.roles).to eq []
        subject.update(roles: [Role::Admin, Role::JuniorCollaborator])
        expect(subject.roles).to eq [Role::Admin, Role::JuniorCollaborator].map(&:to_s)
        expect(subject.reload.roles).to eq [Role::Admin, Role::JuniorCollaborator].map(&:to_s)
        expect(subject.role?(Role::Admin)).to be_truthy
        expect(subject.role?(Role::JuniorCollaborator)).to be_truthy
        expect(subject.role?(Role::SeniorCollaborator)).to be_falsey

        subject.update(roles: [Role::Admin, Role::SeniorCollaborator])
        expect(subject.roles).to eq [Role::Admin, Role::SeniorCollaborator].map(&:to_s)
        expect(subject.reload.roles).to eq [Role::Admin, Role::SeniorCollaborator].map(&:to_s)
        expect(subject.role?(Role::Admin)).to be_truthy
        expect(subject.role?(Role::JuniorCollaborator)).to be_falsey
        expect(subject.role?(Role::SeniorCollaborator)).to be_truthy
      end
    end

    context 'factories' do
      context 'admin' do
        subject { FactoryBot.create(:user, :admin) }
        it 'stores' do
          expect(subject.role?(Role::Admin)).to be_truthy
          expect(subject.role?(Role::JuniorCollaborator)).to be_falsey
          expect(subject.role?(Role::SeniorCollaborator)).to be_falsey
        end
      end
      context 'junior_collaborator' do
        subject { FactoryBot.create(:user, :junior_collaborator) }
        it 'stores' do
          expect(subject.role?(Role::Admin)).to be_falsey
          expect(subject.role?(Role::JuniorCollaborator)).to be_truthy
          expect(subject.role?(Role::SeniorCollaborator)).to be_falsey
        end
      end
    end

    context 'class' do
      before do
        FactoryBot.create(:user, id: 1, email: 'user1@example.com', roles: [Role::Admin])
        FactoryBot.create(:user, id: 2, email: 'user2@example.com', roles: [Role::Admin, Role::JuniorCollaborator])
        FactoryBot.create(:user, id: 3, email: 'user3@example.com', roles: [Role::SeniorCollaborator])
        FactoryBot.create(:user, id: 4, email: 'user4@example.com', roles: [Role::JuniorCollaborator])
        FactoryBot.create(:user, id: 5, email: 'user5@example.com', roles: [])
      end
      it 'filter' do
        expect(described_class.with_role(Role::Admin).pluck(:id)).to              match_array [1, 2]
        expect(described_class.with_role(Role::JuniorCollaborator).pluck(:id)).to match_array [2, 4]
        expect(described_class.with_role(Role::SeniorCollaborator).pluck(:id)).to match_array [3]
      end
    end
  end
end
