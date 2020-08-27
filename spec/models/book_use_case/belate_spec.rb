require 'rails_helper'

RSpec.describe BookUseCase::Belate, type: :model do
  let!(:book) { FactoryBot.create(:book, state: 'borrowed') }
  let!(:lender) { FactoryBot.create(:lender) }
  let!(:loan) { FactoryBot.create(:loan, book: book, lender: lender, due_date: Date.yesterday) }

  context 'valid' do
    subject { described_class.new(book_id: book.id) }

    it 'transactions the book_use_case' do
      expect {
        subject.save
        expect(subject.errors).to be_blank
      }.to change { Loan.count }.by(0)
      expect(book.reload).to be_belated

      expect(loan.reload.due_date).to eq Date.yesterday
      expect(loan.reload.return_date).to be_blank
    end
  end

  context 'invalid' do
    context 'missing book' do
      subject { described_class.new() }

      it 'set error' do
        subject.save
        expect(book.reload).to be_borrowed

        expect(subject.errors[:book_id]).to match_array ["moet opgegeven zijn"]
      end
    end
    context 'book not found' do
      subject { described_class.new(book_id: book.id + 1) }

      it 'set error' do
        subject.save
        expect(book.reload).to be_borrowed

        expect(subject.errors[:book_id]).to match_array ["niet gevonden"]
      end
    end
    context 'book may not be belated' do
      subject { described_class.new(book_id: book.id) }

      it 'set error' do
        book.update(state: 'disabled')
        expect(book.reload).to be_disabled
        subject.save
        expect(book.reload).to be_disabled

        expect(subject.errors[:book_id]).to match_array ["kan niet aangemerkt worden als laat"]
      end
    end

  end
end

