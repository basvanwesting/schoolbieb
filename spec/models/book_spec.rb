require 'rails_helper'

RSpec.describe Book, type: :model do

  describe 'sticker_pending' do
    let!(:author1) { FactoryBot.create(:author, id: 1, first_name: 'Foo') }
    let!(:author2) { FactoryBot.create(:author, id: 2, first_name: 'Bar') }
    subject { FactoryBot.create(:book, reading_level: 'A', avi_level: 'M3', author: author1) }

    it 'defaults to sticker_pending' do
      expect(subject.sticker_pending).to be_truthy
    end

    it 'removes flag on unset_sticker_pending!' do
      subject.unset_sticker_pending!
      expect(subject.sticker_pending).to be_falsey
    end

    it 'sets flag on relevant change (reading_level)' do
      subject.unset_sticker_pending!
      expect(subject.sticker_pending).to be_falsey
      subject.update(reading_level: 'B')
      expect(subject.sticker_pending).to be_truthy
    end

    it 'sets flag on relevant change (author)' do
      subject.unset_sticker_pending!
      expect(subject.sticker_pending).to be_falsey
      subject.update(author: author2)
      expect(subject.sticker_pending).to be_truthy
    end

    it 'sets flag on irrelevant change' do
      subject.unset_sticker_pending!
      expect(subject.sticker_pending).to be_falsey
      subject.update(avi_level: 'M4')
      expect(subject.sticker_pending).to be_falsey
    end

  end

  describe '.to_csv' do
    before do
      FactoryBot.create(:author, id: 1)
      FactoryBot.create(:book_fiction, id: 1, title: 'book1')
      FactoryBot.create(:book_fiction, id: 2, title: 'book2')
      FactoryBot.create(:book_fiction, id: 3, title: 'other')
      FactoryBot.create(:book_non_fiction, id: 4, title: 'book3', category: Book::NonFiction::Categories::ALL.first)
    end

    it 'returns a CSV for a scope' do
      csv = Book.where("title like 'book%'").to_csv
      expect(csv).to eq <<~DOC
       ID;Type;Titel;Reeks;Deel;Categorie;Leesniveau;AVI niveau;Sticker bijwerken?;Auteur ID;Auteur Voornaam;Auteur Tussenvoegsel;Auteur Achternaam
       1;Leesboek;book1;;;;;;true;1;John;;Doe
       2;Leesboek;book2;;;;;;true;1;John;;Doe
       4;Infoboek;book3;;;Beroepen;;;true;;;;
      DOC
    end

  end
end
