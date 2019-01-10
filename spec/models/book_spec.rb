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
end
