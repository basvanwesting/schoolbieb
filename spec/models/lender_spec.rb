require 'rails_helper'

RSpec.describe Lender, type: :model do

  context 'ransack id_lender_wildcard' do
    let!(:lender_1) { FactoryBot.create(:lender, id: 1,  first_name: 'Kees', last_name: 'Vee',  group_name: 'TB3') }
    let!(:lender_2) { FactoryBot.create(:lender, id: 2,  first_name: 'Koos', last_name: 'Vee',  group_name: 'TB2') }
    let!(:lender_3) { FactoryBot.create(:lender, id: 11, first_name: 'Vee',  last_name: 'Stál', group_name: 'TB3') }

    it 'searches' do
      expect(Lender.ransack(id_lender_wildcard: 'Kees Vee').result).to match_array [lender_1]
      expect(Lender.ransack(id_lender_wildcard: 'vee').result).to match_array [lender_1, lender_2, lender_3]
      expect(Lender.ransack(id_lender_wildcard: 'TB3').result).to match_array [lender_1, lender_3]
    end

    it 'searches accents' do
      expect(Lender.ransack(id_lender_wildcard: 'stal').result).to match_array [lender_3]
      expect(Lender.ransack(id_lender_wildcard: 'stál').result).to match_array [lender_3]
      #expect(Lender.ransack(id_lender_wildcard: 'Kees Vée').result).to match_array [lender_1]
      #expect(Lender.ransack(id_lender_wildcard: 'vée').result).to match_array [lender_1, lender_2, lender_3]
    end

    it 'matches description' do
      expect(Lender.ransack(id_lender_wildcard: lender_1.description).result).to match_array [lender_1]
      expect(Lender.ransack(id_lender_wildcard: lender_2.description).result).to match_array [lender_2]
      expect(Lender.ransack(id_lender_wildcard: lender_3.description).result).to match_array [lender_3]
    end

    it 'matches left part of id' do
      expect(Lender.ransack(id_lender_wildcard: '1').result).to   match_array [lender_1, lender_3]
      expect(Lender.ransack(id_lender_wildcard: '11').result).to  match_array [lender_3]
      expect(Lender.ransack(id_lender_wildcard: '2').result).to   match_array [lender_2]
      expect(Lender.ransack(id_lender_wildcard: '002').result).to match_array [lender_2]
    end
  end
end
