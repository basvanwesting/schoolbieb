require 'rails_helper'

RSpec.describe Book, type: :model do

  describe 'extended_title' do
    subject { FactoryBot.build(:book) }

    it 'returns the title if already extended' do
      subject.title = "My first book [[A | B | C]]"
      subject.reading_level = "P"
      subject.avi_level = "M4"
      expect(subject.extended_title).to eq 'My first book [[A | B | C]]'
    end

    it 'extends title if not extended yet' do
      subject.reading_level = "PL"
      subject.avi_level = "M3"
      expect(subject.extended_title).to eq 'My First Book [[PL | M3]]'
    end

    it 'extends title if not extended yet, but noting to extend' do
      expect(subject.extended_title).to eq 'My First Book [[]]'
    end

    it 'persists the extended title if not extended yet' do
      subject.reading_level = "PL"
      subject.avi_level = "M3"
      expect(subject.title).to eq 'My First Book'
      subject.save && subject.reload
      expect(subject.title).to eq 'My First Book [[PL | M3]]'
    end

  end

  describe '.to_csv' do
    before do
      FactoryBot.create(:author, id: 1)
      FactoryBot.create(:book, id: 1, title: 'book1')
      FactoryBot.create(:book, id: 2, title: 'book2')
      FactoryBot.create(:book, id: 3, title: 'other')
    end

    it 'returns a CSV for a scope' do
      csv = Book.where("title like 'book%'").to_csv
      expect(csv).to eq <<~DOC
       id;title;series;part;reading_level;avi_level;sticker_pending;author_id;author_first_name;author_middle_name;author_last_name
       1;book1 [[]];;;;;true;1;John;;Doe
       2;book2 [[]];;;;;true;1;John;;Doe
      DOC
    end

  end
end
