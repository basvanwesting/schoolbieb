require "rails_helper"

RSpec.describe "Search", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  let!(:user) { FactoryBot.create(:user, :junior_collaborator) }
  let!(:author_1) { FactoryBot.create(:author, first_name: 'Kees', last_name: 'Vee')  }
  let!(:author_2) { FactoryBot.create(:author, first_name: 'Koos', last_name: 'Vée')  }
  let!(:author_3) { FactoryBot.create(:author, first_name: 'Vee',  last_name: 'Stál') }

  before do
    sign_in user
  end

  it "baseline test" do
    visit "/"
    click_link "Auteurs", match: :first

    expect(page).to have_text("Vee Kees")
    expect(page).to have_text("Vée Koos")
    expect(page).to have_text("Stál Vee")
  end

  it "search unaccented => accented and unaccented" do
    visit "/"
    click_link "Auteurs", match: :first

    within(".search") do
      fill_in 'q_last_name_cont', with: "vee"
      click_on "Search"
    end

    expect(page).to have_text("Vee Kees")
    expect(page).to have_text("Vée Koos")
    expect(page).to_not have_text("Stál Vee")
  end

  it "search accented => accented and unaccented" do
    visit "/"
    click_link "Auteurs", match: :first

    within(".search") do
      fill_in 'q_last_name_cont', with: "vée"
      click_on "Search"
    end

    expect(page).to have_text("Vee Kees")
    expect(page).to have_text("Vée Koos")
    expect(page).to_not have_text("Stál Vee")
  end
end
