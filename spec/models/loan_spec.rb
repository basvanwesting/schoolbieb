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

      expect(Loan.last.versions.pluck(:event, :object_changes)).to match [
        ["create", "---\nlending_date:\n- \n- 2020-01-01\ndue_date:\n- \n- 2020-01-22\n"],
        ["update", "---\ndue_date:\n- 2020-01-22\n- 2020-02-12\ntimes_prolonged:\n- 0\n- 1\n"],
        ["update", "---\nreturn_date:\n- \n- 2020-01-01\n"],
      ]
    end
  end

end
