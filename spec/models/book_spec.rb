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

  context 'due dates' do
    let!(:lender_1) { FactoryBot.create(:lender, last_name: 'A') }
    let!(:lender_2) { FactoryBot.create(:lender, last_name: 'B') }
    let!(:lender_3) { FactoryBot.create(:lender, last_name: 'C') }
    let!(:book_1) { FactoryBot.create(:book, state: 'borrowed') }
    let!(:book_2) { FactoryBot.create(:book, state: 'borrowed') }
    let!(:book_3) { FactoryBot.create(:book, state: 'borrowed') }
    let!(:loan_1) { FactoryBot.create(:loan, book: book_1, lender: lender_1, due_date: Date.yesterday) }
    let!(:loan_2) { FactoryBot.create(:loan, book: book_2, lender: lender_2, due_date: Date.today)     }
    let!(:loan_3_old) { FactoryBot.create(:loan, book: book_3, lender: lender_1, due_date: Date.yesterday, return_date: Date.today) }
    let!(:loan_3) { FactoryBot.create(:loan, book: book_3, lender: lender_3, due_date: Date.tomorrow)  }

    specify '.check_due_dates!' do
      belated_books = described_class.check_due_dates!

      expect(book_1.reload).to be_belated
      expect(book_2.reload).to be_borrowed
      expect(book_3.reload).to be_borrowed
      expect(belated_books).to match_array(book_1)
    end

    specify 'can ransack on loan_due_today' do
      expect(Book.ransack(loan_due_today_eq: "").result).to match_array [book_1, book_2, book_3]
      expect(Book.ransack(loan_due_today_eq: "1").result).to match_array [book_2]
    end

    specify '#loan returns current loan if present' do
      BookUseCase::Return.new(book_id: book_1.id).save

      expect(book_1.loan).to eq nil
      expect(book_2.loan).to eq loan_2
      expect(book_3.loan).to eq loan_3

      expect(book_1.loan_due_date).to eq nil
      expect(book_2.loan_due_date).to eq Date.today
      expect(book_3.loan_due_date).to eq Date.tomorrow
    end

    specify '#lender returns current lender if present' do
      BookUseCase::Return.new(book_id: book_1.id).save

      expect(book_1.lender).to eq nil
      expect(book_2.lender).to eq lender_2
      expect(book_3.lender).to eq lender_3

      expect(Book.includes(loan: :lender).map(&:lender)).to match_array [nil, lender_2, lender_3]
    end
  end


  context 'ransack id_book_wildcard' do
    let!(:book_1) { FactoryBot.create(:book, id: 1,  title: 'Borre en de beer', series: 'Op pad') }
    let!(:book_2) { FactoryBot.create(:book, id: 2,  title: 'Beer en Káás',     series: 'Dieren') }
    let!(:book_3) { FactoryBot.create(:book, id: 11, title: 'Borre op de Koe',  series: 'Op pad') }

    it 'searches' do
      expect(Book.ransack(id_book_wildcard: 'beer').result).to            match_array [book_1, book_2]
      expect(Book.ransack(id_book_wildcard: 'borre').result).to           match_array [book_1, book_3]
      expect(Book.ransack(id_book_wildcard: 'pad').result).to             match_array [book_1, book_3]
      expect(Book.ransack(id_book_wildcard: 'Borre op de Koe').result).to match_array [book_3]
    end

    it 'searches accents' do
      expect(Book.ransack(id_book_wildcard: 'kaas').result).to match_array [book_2]
      expect(Book.ransack(id_book_wildcard: 'Káás').result).to match_array [book_2]
      expect(Book.ransack(id_book_wildcard: 'béer').result).to match_array [book_1, book_2]
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

  context 'wildcard search, description edge cases' do
    let(:author) { FactoryBot.create(:author) }

    it 'works with start (avi_level) in the name' do
      book = Book::Fiction.create(
        id: 365,
        title: "Fleur gaat van start",
        reading_level: "A",
        avi_level: "PLUS",
        author: author,
        series: "",
        part: nil,
      )

      expect(Book.ransack(id_book_wildcard: book.description).result).to match_array [book]
      expect(book.description).to eq "Fleur gaat van start (0365)"
    end

    it 'works with subset name (solved by ID mismatch)' do
      book = Book::Fiction.create(
        id: 1480,
        title: "Heksje Lilly De reis naar Mandolan",
        reading_level: "A",
        avi_level: "",
        author: author,
        series: "Heksje Lilly",
        part: nil,
      )
      book_alt = Book::Fiction.create(
        id: 21,
        title: "De reis naar Mandolan",
        reading_level: "A",
        avi_level: "",
        author: author,
        series: "",
        part: nil,
      )

      expect(Book.ransack(id_book_wildcard: book.description).result).to match_array [book]
      expect(book.description).to eq "Heksje Lilly De reis naar Mandolan (1480)"

      expect(Book.ransack(id_book_wildcard: book_alt.description).result).to match_array [book_alt]
      expect(book_alt.description).to eq "De reis naar Mandolan (0021)"
    end

    it 'works with subset name (not solved by ID mismatch)' do
      book = Book::Fiction.create(
        id: 18,
        title: "Mei",
        reading_level: "A",
        avi_level: "",
        author: author,
        series: "",
        part: nil,
      )
      book_alt = Book::Fiction.create(
        id: 1805,
        title: "Het meisje met de groene ogen",
        reading_level: "A",
        avi_level: "",
        author: author,
        series: "",
        part: nil,
      )

      expect(Book.ransack(id_book_wildcard: book.description).result).to match_array [book, book_alt]
      expect(book.description).to eq "Mei (0018)"

      expect(Book.ransack(id_book_wildcard: book_alt.description).result).to match_array [book_alt]
      expect(book_alt.description).to eq "Het meisje met de groene ogen (1805)"
    end

    it 'works with quote' do
      book = Book::Fiction.create(
        id: 1047,
        title: "Niek de Groot flikt het 'm weer",
        reading_level: "B",
        avi_level: "",
        author: author,
        series: "",
        part: nil,
      )

      expect(Book.ransack(id_book_wildcard: book.description).result).to match_array [book]
      expect(book.description).to eq "Niek de Groot flikt het 'm weer (1047)"
    end

    it 'works with comma' do
      book = Book::Fiction.create(
        id: 444,
        title: "Mijn gemuts 3,5",
        reading_level: "B",
        avi_level: "",
        author: author,
        series: "Dagboek van een muts",
        part: nil,
      )

      expect(Book.ransack(id_book_wildcard: book.description).result).to match_array [book]
      expect(book.description).to eq "Mijn gemuts 3,5 (0444)"
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
