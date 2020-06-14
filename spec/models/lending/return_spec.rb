require 'rails_helper'

RSpec.describe Lending::Return, type: :model do
  let!(:book) { FactoryBot.create(:book, state: 'borrowed') }
  let!(:lender) { FactoryBot.create(:lender) }
  let!(:loan) { FactoryBot.create(:loan, book: book, lender: lender) }

  context 'valid' do
    subject { described_class.new(book_id: book.id) }

    it 'transactions the lending' do
      expect {
        subject.save
      }.to change { Loan.count }.by(0)
      expect(book.reload).to be_available
      expect(loan.reload.return_date).to eq Date.today
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
    context 'book may not be returned' do
      subject { described_class.new(book_id: book.id) }

      it 'set error' do
        book.update(state: 'disabled')
        expect(book.reload).to be_disabled
        subject.save
        expect(book.reload).to be_disabled

        expect(subject.errors[:book_id]).to match_array ["kan niet geretourneerd worden"]
      end
    end

  end
end

