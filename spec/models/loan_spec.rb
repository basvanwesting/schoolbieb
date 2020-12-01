require 'rails_helper'

RSpec.describe Loan, type: :model do

  before { Timecop.freeze('2020-01-01T12:00:00Z') }
  after { Timecop.return }

  describe "paper_trail" do
    let!(:book) { FactoryBot.create(:book) }
    let!(:lender) { FactoryBot.create(:lender) }

    it 'tracks the paper_trail' do
      BookUseCase::Borrow.new(book_id: book.id, lender_id: lender.id).save
      BookUseCase::Prolong.new(book_id: book.id).save
      BookUseCase::Return.new(book_id: book.id).save

      expect(Loan.last.versions.pluck(:event, :object_changes).flatten.map(&:squish)).to match [
        ["create", "---\nlending_date:\n- \n- 2020-01-01\ndue_date:\n- \n- 2020-01-22\n"],
        ["update", "---\ndue_date:\n- 2020-01-22\n- 2020-02-12\ntimes_prolonged:\n- 0\n- 1\n"],
        ["update", "---\nreturn_date:\n- \n- 2020-01-01\n"],
      ].flatten.map(&:squish)
    end
  end

  describe ".sanitize_due_date" do
    before do
      FactoryBot.create(
        :vacation,
        start_date: '2020-03-01',
        end_date: '2020-03-14',
        due_date: '2020-02-28',
      )
    end
    it 'leaves unchanged for weekday, no vacation' do
      expect(described_class.sanitize_due_date('2020-03-16')).to eq '2020-03-16'.to_date
      expect(described_class.sanitize_due_date('2020-03-17')).to eq '2020-03-17'.to_date
      expect(described_class.sanitize_due_date('2020-03-18')).to eq '2020-03-18'.to_date
      expect(described_class.sanitize_due_date('2020-03-19')).to eq '2020-03-19'.to_date
      expect(described_class.sanitize_due_date('2020-03-20'.to_date)).to eq '2020-03-20'.to_date
    end
    it 'changes to next monday on weekend, no vacation' do
      expect(described_class.sanitize_due_date('2020-03-21')).to         eq '2020-03-23'.to_date
      expect(described_class.sanitize_due_date('2020-03-22'.to_date)).to eq '2020-03-23'.to_date
    end
    it 'changes to new due-date, when in vacation' do
      expect(described_class.sanitize_due_date('2020-03-01')).to eq '2020-02-28'.to_date
      expect(described_class.sanitize_due_date('2020-03-10')).to eq '2020-02-28'.to_date
      expect(described_class.sanitize_due_date('2020-03-14')).to eq '2020-02-28'.to_date
    end
    it 'returns nil on invalid date' do
      expect(described_class.sanitize_due_date('FOO')).to eq nil
      expect(described_class.sanitize_due_date('')).to    eq nil
      expect(described_class.sanitize_due_date(nil)).to   eq nil
    end

  end

end
