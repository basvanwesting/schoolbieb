require 'rails_helper'

RSpec.describe Lending::Borrow, type: :model do
  let!(:book)   { FactoryBot.create(:book)   }
  let!(:lender) { FactoryBot.create(:lender) }

  context 'valid' do
    subject { described_class.new(book_id: book.id, lender_id: lender.id) }

    it 'transactions the lending' do
      expect {
        subject.save
      }.to change { Loan.count }.by(1)
      expect(book.reload).to be_borrowed
    end
  end

  context 'invalid' do
    context 'missing book' do
      subject { described_class.new(lender_id: lender.id) }

      it 'set error' do
        expect {
          subject.save
        }.to change { Loan.count }.by(0)
        expect(book.reload).to be_available

        expect(subject.errors[:book_id]).to match_array ["moet opgegeven zijn"]
      end
    end
    context 'book not found' do
      subject { described_class.new(lender_id: lender.id, book_id: book.id + 1) }

      it 'set error' do
        expect {
          subject.save
        }.to change { Loan.count }.by(0)
        expect(book.reload).to be_available

        expect(subject.errors[:book_id]).to match_array ["niet gevonden"]
      end
    end
    context 'book may not be borrowed' do
      subject { described_class.new(lender_id: lender.id, book_id: book.id) }

      it 'set error' do
        book.disable!
        expect(book.reload).to be_disabled
        expect {
          subject.save
        }.to change { Loan.count }.by(0)
        expect(book.reload).to be_disabled

        expect(subject.errors[:book_id]).to match_array ["kan niet uitgeleend worden"]
      end
    end

  end
end
