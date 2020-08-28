require "rails_helper"

RSpec.describe "Borrow Book", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end


  context 'authorised' do
    let!(:user) { FactoryBot.create(:user, :junior_collaborator) }

    before do
      sign_in user
    end

    context 'transition allowed' do
      let!(:book) { FactoryBot.create(:book, state: 'available') }
      let!(:lender) { FactoryBot.create(:lender) }

      context 'valid form, default due_date' do
        it "borrows the book" do
          visit "/"
          click_link "Uitlenen", match: :first

          expect do
            within("form") do
              fill_in 'Boek', with: "First"
              expect(page).to have_field('Boek', with: book.description) #wait for autocomplete
              fill_in 'Kind', with: "John"
              expect(page).to have_field('Kind', with: lender.description) #wait for autocomplete
              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(1)

          expect(page).to have_text("Succesvol uitgeleend")
          expect(book.reload).to be_borrowed

          loan = Loan.first
          expect(loan.book).to         eq book
          expect(loan.lender).to       eq lender
          expect(loan.lending_date).to eq Date.today
          expect(loan.due_date).to     eq Date.today + BookUseCase::Borrow::DEFAULT_DUE_DATE_INTERVAL
          expect(loan.return_date).to  eq nil
        end
      end

      context 'valid form, manual due_date' do
        it "borrows the book" do
          visit "/"
          click_link "Uitlenen", match: :first

          expect do
            within("form") do
              fill_in 'Boek', with: "First"
              expect(page).to have_field('Boek', with: book.description) #wait for autocomplete
              fill_in 'Kind', with: "John"
              expect(page).to have_field('Kind', with: lender.description) #wait for autocomplete
              fill_in 'Retourdatum', with: Date.tomorrow.to_s
              first('input.datepicker').send_keys :tab
              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(1)

          expect(page).to have_text("Succesvol uitgeleend")
          expect(book.reload).to be_borrowed

          loan = Loan.first
          expect(loan.book).to         eq book
          expect(loan.lender).to       eq lender
          expect(loan.lending_date).to eq Date.today
          expect(loan.due_date).to     eq Date.tomorrow
          expect(loan.return_date).to  eq nil
        end
      end

      context 'invalid form, missing lender' do
        it "borrows the book" do
          visit "/"
          click_link "Uitlenen", match: :first

          expect do
            within("form") do
              fill_in 'Boek', with: "First"
              expect(page).to have_field('Boek', with: book.description) #wait for autocomplete
              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(0)

          expect(page).to have_text("Zie onderstaande problemen")
          expect(page).to have_text("moet opgegeven zijn")
          expect(book.reload).to be_available
        end
      end
    end

    context 'transition not allowed' do
      let!(:book) { FactoryBot.create(:book, state: 'disabled') }
      let!(:lender) { FactoryBot.create(:lender) }

      context 'invalid form, missing book' do
        it "borrows the book" do
          visit "/"
          click_link "Uitlenen", match: :first

          expect do
            within("form") do
              fill_in 'Boek', with: "First"
              fill_in 'Kind', with: "John"
              expect(page).to have_field('Kind', with: lender.description) #wait for autocomplete
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

    it "no borrow link" do
      visit "/"
      expect { click_link "Uitlenen", match: :first }.to raise_error(Capybara::ElementNotFound)
    end
  end
end
