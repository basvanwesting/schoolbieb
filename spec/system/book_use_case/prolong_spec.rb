require "rails_helper"

RSpec.describe "Prolong Book", type: :system do
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

      context 'valid form, in time' do
        it "prolongs the book" do
          visit "/"
          click_link "Verlengen", match: :first

          expect do
            within("form") do
              fill_in 'Boek', with: "First"
              expect(page).to have_field('Boek', with: book.description) #wait for autocomplete
              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(0)

          expect(page).to have_text("Succesvol verlengd")
          expect(book.reload).to be_borrowed

          loan = Loan.first
          expect(loan.book).to         eq book
          expect(loan.lender).to       eq lender
          expect(loan.lending_date).to eq Date.yesterday
          expect(loan.due_date).to     eq Date.tomorrow + BookUseCase::Prolong::DEFAULT_DUE_DATE_INTERVAL
          expect(loan.return_date).to  eq nil
        end
      end

      context 'valid form, from belated' do
        before do
          loan.update(due_date: Date.yesterday)
          book.belate!
        end

        it "prolongs the book" do
          visit "/"
          click_link "Verlengen", match: :first

          expect do
            within("form") do
              fill_in 'Boek', with: "First"
              expect(page).to have_field('Boek', with: book.description) #wait for autocomplete
              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(0)

          expect(page).to have_text("Succesvol verlengd")
          expect(book.reload).to be_borrowed

          loan = Loan.first
          expect(loan.book).to         eq book
          expect(loan.lender).to       eq lender
          expect(loan.lending_date).to eq Date.yesterday
          expect(loan.due_date).to     eq Date.today + BookUseCase::Prolong::DEFAULT_DUE_DATE_INTERVAL
          expect(loan.return_date).to  eq nil
        end
      end

      context 'invalid form, missing book' do
        it "prolongs the book" do
          visit "/"
          click_link "Verlengen", match: :first

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
        it "prolongs the book" do
          visit "/"
          click_link "Verlengen", match: :first

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

    it "no prolong link" do
      visit "/"
      expect { click_link "Verlengen", match: :first }.to raise_error(Capybara::ElementNotFound)
    end
  end
end
