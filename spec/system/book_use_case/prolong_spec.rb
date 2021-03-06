require "rails_helper"

RSpec.describe "Prolong Book", type: :system do
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
      let!(:book) { FactoryBot.create(:book, state: 'borrowed') }
      let!(:lender) { FactoryBot.create(:lender) }
      let!(:loan) { FactoryBot.create(:loan, book: book, lender: lender, lending_date: '2020-11-30', due_date: '2020-12-02') }

      context 'valid form, in time' do
        # FIXME: existing loan's due_date is not present yet when form is generated, so due_date achors on today instead of tomorrow.
        it "prolongs the book" do
          visit "/"
          click_link "Verlengen", match: :first

          expect do
            within("form") do
              fill_in 'Boek', with: "First"
              find("datalist#books option[value='#{book.description}']", visible: :all)
              select(book.description, from: 'Boek')
              find("input#book_use_case_prolong_book_id[value='#{book.id}']", visible: false)

              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(0)

          expect(page).to have_text("Succesvol verlengd")
          expect(book.reload).to be_borrowed

          loan = Loan.first
          expect(loan.book).to         eq book
          expect(loan.lender).to       eq lender
          expect(loan.lending_date).to eq '2020-11-30'.to_date
          expect(loan.due_date).to     eq '2020-12-01'.to_date + BookUseCase::Prolong::DEFAULT_DUE_DATE_INTERVAL
          expect(loan.return_date).to  eq nil
        end
      end

      context 'valid form, in time, modified due_date by vacation' do
        before do
          FactoryBot.create(
            :vacation,
            start_date: '2020-12-20',
            end_date: '2021-01-07',
            due_date: '2020-12-18',
          )
        end
        # FIXME: existing loan's due_date is not present yet when form is generated, so due_date achors on today instead of tomorrow.
        it "prolongs the book" do
          visit "/"
          click_link "Verlengen", match: :first

          expect do
            within("form") do
              fill_in 'Boek', with: "First"
              find("datalist#books option[value='#{book.description}']", visible: :all)
              select(book.description, from: 'Boek')
              find("input#book_use_case_prolong_book_id[value='#{book.id}']", visible: false)

              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(0)

          expect(page).to have_text("Succesvol verlengd")
          expect(book.reload).to be_borrowed

          loan = Loan.first
          expect(loan.book).to         eq book
          expect(loan.lender).to       eq lender
          expect(loan.lending_date).to eq '2020-11-30'.to_date
          expect(loan.due_date).to     eq '2020-12-18'.to_date
          expect(loan.return_date).to  eq nil
        end
      end

      context 'valid form, from belated, default due_date' do
        before do
          loan.update(due_date: '2020-11-30'.to_date)
          book.belate!
        end

        it "prolongs the book" do
          visit "/"
          click_link "Verlengen", match: :first

          expect do
            within("form") do
              fill_in 'Boek', with: "First"
              find("datalist#books option[value='#{book.description}']", visible: :all)
              select(book.description, from: 'Boek')
              find("input#book_use_case_prolong_book_id[value='#{book.id}']", visible: false)

              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(0)

          expect(page).to have_text("Succesvol verlengd")
          expect(book.reload).to be_borrowed

          loan = Loan.first
          expect(loan.book).to         eq book
          expect(loan.lender).to       eq lender
          expect(loan.lending_date).to eq '2020-11-30'.to_date
          expect(loan.due_date).to     eq '2020-12-01'.to_date + BookUseCase::Prolong::DEFAULT_DUE_DATE_INTERVAL
          expect(loan.return_date).to  eq nil
        end
      end

      context 'valid form, from belated, manual due_date' do
        before do
          loan.update(due_date: '2020-11-30'.to_date)
          book.belate!
        end

        it "prolongs the book" do
          visit "/"
          click_link "Verlengen", match: :first

          expect do
            within("form") do
              fill_in 'Boek', with: "First"
              find("datalist#books option[value='#{book.description}']", visible: :all)
              select(book.description, from: 'Boek')
              find("input#book_use_case_prolong_book_id[value='#{book.id}']", visible: false)

              fill_in 'Retourdatum', with: '2020-12-02'
              first('input.datepicker').send_keys :tab
              click_on "Opslaan"
            end
          end.to change { Loan.count }.by(0)

          expect(page).to have_text("Succesvol verlengd")
          expect(book.reload).to be_borrowed

          loan = Loan.first
          expect(loan.book).to         eq book
          expect(loan.lender).to       eq lender
          expect(loan.lending_date).to eq '2020-11-30'.to_date
          expect(loan.due_date).to     eq '2020-12-02'.to_date
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
              expect {
                find("datalist#books option[value='#{book.description}']", visible: :all)
              }.to raise_error(Capybara::ElementNotFound)

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
