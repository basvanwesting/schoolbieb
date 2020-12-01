require "rails_helper"

RSpec.describe "Borrow Book", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    Timecop.freeze('2020-12-01T12:00:00Z')
  end

  after { Timecop.return }

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
              find("datalist#books option[value='#{book.description}']", visible: :all)
              select(book.description, from: 'Boek')
              find("input#book_use_case_borrow_book_id[value='#{book.id}']", visible: false)

              fill_in 'Kind', with: "John"
              find("datalist#lenders option[value='#{lender.description}']", visible: :all)
              select(lender.description, from: 'Kind')
              find("input#book_use_case_borrow_lender_id[value='#{lender.id}']", visible: false)

              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(1)

          expect(page).to have_text("Succesvol uitgeleend")
          expect(book.reload).to be_borrowed

          loan = Loan.first
          expect(loan.book).to         eq book
          expect(loan.lender).to       eq lender
          expect(loan.lending_date).to eq '2020-12-01'.to_date
          expect(loan.due_date).to     eq '2020-12-01'.to_date + BookUseCase::Borrow::DEFAULT_DUE_DATE_INTERVAL
          expect(loan.return_date).to  eq nil
        end
      end

      context 'valid form, modified due_date by vacation' do
        before do
          FactoryBot.create(
            :vacation,
            start_date: '2020-12-20',
            end_date: '2021-01-07',
            due_date: '2020-12-18',
          )
        end
        it "borrows the book" do
          visit "/"
          click_link "Uitlenen", match: :first

          expect do
            within("form") do
              fill_in 'Boek', with: "First"
              find("datalist#books option[value='#{book.description}']", visible: :all)
              select(book.description, from: 'Boek')
              find("input#book_use_case_borrow_book_id[value='#{book.id}']", visible: false)

              fill_in 'Kind', with: "John"
              find("datalist#lenders option[value='#{lender.description}']", visible: :all)
              select(lender.description, from: 'Kind')
              find("input#book_use_case_borrow_lender_id[value='#{lender.id}']", visible: false)

              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(1)

          expect(page).to have_text("Succesvol uitgeleend")
          expect(book.reload).to be_borrowed

          loan = Loan.first
          expect(loan.book).to         eq book
          expect(loan.lender).to       eq lender
          expect(loan.lending_date).to eq '2020-12-01'.to_date
          expect(loan.due_date).to     eq '2020-12-18'.to_date
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
              find("datalist#books option[value='#{book.description}']", visible: :all)
              select(book.description, from: 'Boek')
              find("input#book_use_case_borrow_book_id[value='#{book.id}']", visible: false)

              fill_in 'Kind', with: "John"
              find("datalist#lenders option[value='#{lender.description}']", visible: :all)
              select(lender.description, from: 'Kind')
              find("input#book_use_case_borrow_lender_id[value='#{lender.id}']", visible: false)

              fill_in 'Retourdatum', with: '2020-12-02'
              first('input.datepicker').send_keys :tab

              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(1)

          expect(page).to have_text("Succesvol uitgeleend")
          expect(book.reload).to be_borrowed

          loan = Loan.first
          expect(loan.book).to         eq book
          expect(loan.lender).to       eq lender
          expect(loan.lending_date).to eq '2020-12-01'.to_date
          expect(loan.due_date).to     eq '2020-12-02'.to_date
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
              find("datalist#books option[value='#{book.description}']", visible: :all)
              select(book.description, from: 'Boek')
              find("input#book_use_case_borrow_book_id[value='#{book.id}']", visible: false)

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
              expect {
                find("datalist#books option[value='#{book.description}']", visible: :all)
              }.to raise_error(Capybara::ElementNotFound)

              fill_in 'Kind', with: "John"
              find("datalist#lenders option[value='#{lender.description}']", visible: :all)
              select(lender.description, from: 'Kind')
              find("input#book_use_case_borrow_lender_id[value='#{lender.id}']", visible: false)

              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(0)

          expect(page).to have_text("Zie onderstaande problemen")
          expect(page).to have_text("moet opgegeven zijn")
          expect(book.reload).to be_disabled
        end
      end
    end

    context 'complex situations' do
      let!(:book_alt) { FactoryBot.create(
        :book,
        id: 1805,
        title: "Het meisje met de groene ogen",
        state: "available"
      )}
      let!(:book) { FactoryBot.create(
        :book,
        id: 18,
        title: "Mei",
        state: "available"
      )}
      let!(:lender) { FactoryBot.create(:lender) }

      context 'book with with subset name (not solved by ID mismatch)' do
        it "borrows the book" do
          visit "/"
          click_link "Uitlenen", match: :first

          expect do
            within("form") do
              fill_in 'Boek', with: "mei"
              find("datalist#books option[value='#{book.description}']", visible: :all)
              select(book.description, from: 'Boek')
              find("input#book_use_case_borrow_book_id[value='#{book.id}']", visible: false)

              fill_in 'Kind', with: "John"
              find("datalist#lenders option[value='#{lender.description}']", visible: :all)
              select(lender.description, from: 'Kind')
              find("input#book_use_case_borrow_lender_id[value='#{lender.id}']", visible: false)

              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(1)

          expect(page).to have_text("Succesvol uitgeleend")
          expect(book.reload).to be_borrowed

          loan = Loan.first
          expect(loan.book).to         eq book
          expect(loan.lender).to       eq lender
          expect(loan.lending_date).to eq '2020-12-01'.to_date
          expect(loan.due_date).to     eq '2020-12-01'.to_date + BookUseCase::Borrow::DEFAULT_DUE_DATE_INTERVAL
          expect(loan.return_date).to  eq nil
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
