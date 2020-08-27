require 'rails_helper'

RSpec.describe Book, type: :model do

  describe 'AASM' do
    subject { FactoryBot.create(:book, reading_level: 'A', avi_level: 'M3', state: 'pending') }

    it 'has a life cycle' do
      expect(subject).to be_pending
      subject.enable!
      expect(subject).to be_available
      subject.borrow!
      expect(subject).to be_borrowed
      subject.return!
      expect(subject).to be_available

      expect { subject.return! }.to raise_error(AASM::InvalidTransition)
    end

    it 'default state to available' do
      expect(Book.new).to be_available
    end

  end

  context 'ransack id_book_wildcard' do
    let!(:book_1) { FactoryBot.create(:book, id: 1,  title: 'Borre en de beer', series: 'Op pad') }
    let!(:book_2) { FactoryBot.create(:book, id: 2,  title: 'Beer en Kaas',     series: 'Dieren') }
    let!(:book_3) { FactoryBot.create(:book, id: 11, title: 'Borre op de Koe',  series: 'Op pad') }

    it 'searches' do
      expect(Book.ransack(id_book_wildcard: 'beer').result).to            match_array [book_1, book_2]
      expect(Book.ransack(id_book_wildcard: 'borre').result).to           match_array [book_1, book_3]
      expect(Book.ransack(id_book_wildcard: 'pad').result).to             match_array [book_1, book_3]
      expect(Book.ransack(id_book_wildcard: 'Borre op de Koe').result).to match_array [book_3]
    end

    it 'matches description' do
      expect(Book.ransack(id_book_wildcard: book_1.description).result).to match_array [book_1]
      expect(Book.ransack(id_book_wildcard: book_2.description).result).to match_array [book_2]
      expect(Book.ransack(id_book_wildcard: book_3.description).result).to match_array [book_3]
    end

    it 'matches left part of id' do
      expect(Book.ransack(id_book_wildcard: '1').result).to   match_array [book_1, book_3]
      expect(Book.ransack(id_book_wildcard: '11').result).to  match_array [book_3]
      expect(Book.ransack(id_book_wildcard: '2').result).to   match_array [book_2]
      expect(Book.ransack(id_book_wildcard: '002').result).to match_array [book_2]
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
       ID;Type;Titel;Reeks;Deel;Categorie;Leesniveau;AVI niveau;Auteur ID;Auteur Voornaam;Auteur Tussenvoegsel;Auteur Achternaam
       1;Leesboek;book1;;;;;;1;John;;Doe
       2;Leesboek;book2;;;;;;1;John;;Doe
       4;Infoboek;book3;;;Beroepen;;;;;;
      DOC
    end

  end
end
