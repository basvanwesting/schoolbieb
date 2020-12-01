require 'rails_helper'

RSpec.describe Loan, type: :model do

  before { Timecop.freeze('2020-12-01T12:00:00Z') }
  after { Timecop.return }

  describe "paper_trail" do
    let!(:book) { FactoryBot.create(:book) }
    let!(:lender) { FactoryBot.create(:lender) }

    it 'tracks the paper_trail' do
      BookUseCase::Borrow.new(book_id: book.id, lender_id: lender.id).save
      BookUseCase::Prolong.new(book_id: book.id).save
      BookUseCase::Return.new(book_id: book.id).save

      expect(Loan.last.versions.pluck(:event, :object_changes).flatten.map(&:squish)).to match [
        ["create", "---\nlending_date:\n- \n- 2020-12-01\ndue_date:\n- \n- 2020-12-22\n"],
        ["update", "---\ndue_date:\n- 2020-12-22\n- 2021-01-12\ntimes_prolonged:\n- 0\n- 1\n"],
        ["update", "---\nreturn_date:\n- \n- 2020-12-01\n"],
      ].flatten.map(&:squish)
    end
  end

  describe ".sanitize_due_date" do
    before do
      FactoryBot.create(
        :vacation,
        start_date: '2020-12-21',
        end_date: '2021-01-01',
        due_date: '2020-12-18',
      )
    end
    it 'leaves unchanged for weekday, no vacation' do
      expect(described_class.sanitize_due_date('2020-12-14')).to eq '2020-12-14'.to_date
      expect(described_class.sanitize_due_date('2020-12-15')).to eq '2020-12-15'.to_date
      expect(described_class.sanitize_due_date('2020-12-16')).to eq '2020-12-16'.to_date
      expect(described_class.sanitize_due_date('2020-12-17')).to eq '2020-12-17'.to_date
      expect(described_class.sanitize_due_date('2020-12-18'.to_date)).to eq '2020-12-18'.to_date
    end
    it 'changes to next monday on weekend, no vacation' do
      expect(described_class.sanitize_due_date('2020-12-12')).to         eq '2020-12-14'.to_date
      expect(described_class.sanitize_due_date('2020-12-13'.to_date)).to eq '2020-12-14'.to_date
    end
    it 'changes to new due-date, when in vacation' do
      expect(described_class.sanitize_due_date('2020-12-21')).to eq '2020-12-18'.to_date
      expect(described_class.sanitize_due_date('2020-12-24')).to eq '2020-12-18'.to_date
      expect(described_class.sanitize_due_date('2021-01-01')).to eq '2020-12-18'.to_date
    end
    it 'handles weekend before vacations' do
      expect(described_class.sanitize_due_date('2020-12-19')).to eq '2020-12-18'.to_date
      expect(described_class.sanitize_due_date('2020-12-20')).to eq '2020-12-18'.to_date
    end
    it 'handles weekend after vacations' do
      expect(described_class.sanitize_due_date('2021-01-02')).to eq '2021-01-04'.to_date
      expect(described_class.sanitize_due_date('2021-01-03')).to eq '2021-01-04'.to_date
    end
    it 'returns nil on invalid date' do
      expect(described_class.sanitize_due_date('FOO')).to eq nil
      expect(described_class.sanitize_due_date('')).to    eq nil
      expect(described_class.sanitize_due_date(nil)).to   eq nil
    end

  end

end
