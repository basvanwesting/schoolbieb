require 'rails_helper'

RSpec.describe BookUseCase::Disable, type: :model do
  let!(:book) { FactoryBot.create(:book, state: 'available') }

  context 'valid' do
    subject { described_class.new(book_id: book.id) }

    it 'transactions' do
      subject.save
      expect(book.reload).to be_disabled
    end
  end

  context 'invalid' do
    context 'missing book' do
      subject { described_class.new() }

      it 'set error' do
        subject.save
        expect(book.reload).to be_available

        expect(subject.errors[:book_id]).to match_array ["moet opgegeven zijn"]
      end
    end
    context 'book not found' do
      subject { described_class.new(book_id: book.id + 1) }

      it 'set error' do
        subject.save
        expect(book.reload).to be_available

        expect(subject.errors[:book_id]).to match_array ["niet gevonden"]
      end
    end
    context 'book may not be disabled' do
      subject { described_class.new(book_id: book.id) }

      it 'set error' do
        book.update(state: 'borrowed')
        expect(book.reload).to be_borrowed
        subject.save
        expect(book.reload).to be_borrowed

        expect(subject.errors[:book_id]).to match_array ["kan niet geblokkeerd worden"]
      end
    end

  end
end

