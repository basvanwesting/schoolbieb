require 'rails_helper'

RSpec.describe BookUseCase::Enable, type: :model do
  let!(:book) { FactoryBot.create(:book, state: 'pending') }

  context 'valid' do
    subject { described_class.new(book_id: book.id) }

    it 'transactions' do
      subject.save
      expect(book.reload).to be_available
    end
  end

  context 'invalid' do
    context 'missing book' do
      subject { described_class.new() }

      it 'set error' do
        subject.save
        expect(book.reload).to be_pending

        expect(subject.errors[:book_id]).to match_array ["moet opgegeven zijn"]
      end
    end
    context 'book not found' do
      subject { described_class.new(book_id: book.id + 1) }

      it 'set error' do
        subject.save
        expect(book.reload).to be_pending

        expect(subject.errors[:book_id]).to match_array ["niet gevonden"]
      end
    end
    context 'book may not be enabled' do
      subject { described_class.new(book_id: book.id) }

      it 'set error' do
        book.update(state: 'borrowed')
        expect(book.reload).to be_borrowed
        subject.save
        expect(book.reload).to be_borrowed

        expect(subject.errors[:book_id]).to match_array ["kan niet beschikbaar gemaakt worden"]
      end
    end

  end
end

