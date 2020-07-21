require 'rails_helper'

RSpec.describe Book::NonFiction, type: :model do

  context 'validations' do
    it 'requires' do
      expect(subject.valid?).to be_falsey
      expect(subject.errors[:author]).to be_blank
      expect(subject.errors[:title]).to eq ["moet opgegeven zijn"]
      expect(subject.errors[:category]).to eq ["moet opgegeven zijn"]
    end
  end

  context 'tags' do
    context 'model' do
      subject { FactoryBot.create(:book_non_fiction) }

      it 'stores' do
        expect(subject.tags).to eq []
        subject.update(tags: %w[abc def ghi])
        expect(subject.tags).to eq %w[abc def ghi]
        expect(subject.reload.tags).to eq %w[abc def ghi]

        subject.update(tags: %w[abc ghi jkl])
        expect(subject.tags).to eq %w[abc ghi jkl]
        expect(subject.reload.tags).to eq %w[abc ghi jkl]
      end
    end
    context 'class' do
      before do
        FactoryBot.create(:book_non_fiction, id: 1, tags: %w[ijk])
        FactoryBot.create(:book_non_fiction, id: 2, tags: %w[abc def ghi])
        FactoryBot.create(:book_non_fiction, id: 3, tags: %w[abc ghi])
        FactoryBot.create(:book_non_fiction, id: 4, tags: %w[ghi ijk])
        FactoryBot.create(:book_non_fiction, id: 5, tags: %w[])
      end
      it 'sorted_existing_tags' do
        expect(described_class.sorted_existing_tags).to eq ["abc", "def", "ghi", "ijk"]
      end
      it 'filter' do
        expect(described_class.with_tag('ijk').pluck(:id)).to eq [1, 4]
      end
    end
  end

end

