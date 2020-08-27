require "rails_helper"

RSpec.describe "Return Book", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end


  context 'authorised' do
    let!(:user) { FactoryBot.create(:user, :junior_collaborator) }

    before do
      sign_in user
    end

    context 'transition allowed' do
      let!(:book) { FactoryBot.create(:book, state: 'borrowed') }
      let!(:lender) { FactoryBot.create(:lender) }
      let!(:loan) { FactoryBot.create(:loan, book: book, lender: lender, lending_date: Date.yesterday, due_date: Date.tomorrow) }

      context 'valid form' do
        it "returns the book" do
          visit "/"
          click_link "Retourneren", match: :first

          expect do
            within("form") do
              fill_in 'Boek', with: "First"
              expect(page).to have_field('Boek', with: book.description) #wait for autocomplete
              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(0)

          expect(page).to have_text("Succesvol geretourneerd")
          expect(book.reload).to be_available

          loan = Loan.first
          expect(loan.book).to         eq book
          expect(loan.lender).to       eq lender
          expect(loan.lending_date).to eq Date.yesterday
          expect(loan.due_date).to     eq Date.tomorrow
          expect(loan.return_date).to  eq Date.today
        end
      end

      context 'invalid form, missing book' do
        it "retuns the book" do
          visit "/"
          click_link "Retourneren", match: :first

          expect do
            within("form") do
              fill_in 'Boek', with: "FooBar"
              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(0)

          expect(page).to have_text("Zie onderstaande problemen")
          expect(page).to have_text("moet opgegeven zijn")
          expect(book.reload).to be_borrowed
        end
      end
    end

    context 'transition not allowed' do
      let!(:book) { FactoryBot.create(:book, state: 'disabled') }
      let!(:lender) { FactoryBot.create(:lender) }

      context 'invalid form, missing book' do
        it "returns the book" do
          visit "/"
          click_link "Retourneren", match: :first

          expect do
            within("form") do
              fill_in 'Boek', with: "First"
              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(0)

          expect(page).to have_text("Zie onderstaande problemen")
          expect(page).to have_text("moet opgegeven zijn")
          expect(book.reload).to be_disabled
        end
      end
    end
  end

  context 'not authorised' do
    let!(:user) { FactoryBot.create(:user) }

    before do
      sign_in user
    end

    it "no return link" do
      visit "/"
      expect { click_link "Retourneren", match: :first }.to raise_error(Capybara::ElementNotFound)
    end
  end
end
