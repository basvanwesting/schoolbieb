require "rails_helper"

RSpec.describe "Enable Book", type: :system do
  before do
    driven_by(:rack_test)
  end


  context 'authorised' do
    let!(:user) { FactoryBot.create(:user, :senior_collaborator) }

    before do
      sign_in user
    end

    context 'transition allowed' do
      let!(:book) { FactoryBot.create(:book, state: 'pending') }

      it "enables the book" do
        visit "/"
        click_link "Boeken", match: :first
        click_link "Beschikbaar Maken"
        expect(page).to have_text("Succesvol beschikbaar gemaakt")
        expect(book.reload).to be_available
      end
    end

    context 'transition not allowed' do
      let!(:book) { FactoryBot.create(:book, state: 'available') }

      it "has no enable link" do
        visit "/"
        click_link "Boeken", match: :first
        expect { find_link("Beschikbaar Maken") }.to raise_error(Capybara::ElementNotFound)
      end
    end
  end

  context 'not authorised' do
    let!(:user) { FactoryBot.create(:user, :junior_collaborator) }

    before do
      sign_in user
    end

    context 'transition allowed' do
      let!(:book) { FactoryBot.create(:book, state: 'pending') }

      it "has no enable link" do
        visit "/"
        click_link "Boeken", match: :first
        expect { find_link("Beschikbaar Maken") }.to raise_error(Capybara::ElementNotFound)
      end
    end
  end
end
