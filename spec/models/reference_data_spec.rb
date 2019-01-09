require 'spec_helper'

RSpec.describe ReferenceData, type: :model do

  describe '.enriched_titles' do
    it 'has a lot of them' do
      expect(described_class.enriched_titles.size).to satisfy { |v| v > 1000 }
    end

    it 'supports a title_cont filter' do
      expect(described_class.enriched_titles(title_cont: 'weerwol')).to match_array [
        "Dolfje weerwolfje [[A]]",
        "Dolfje weerwolfje [[B]]",
        "Een miniheks in het weerwolvenbos [[A]]",
        "Een weerwolf in de leeuwenkuil [[A]]",
        "Lief weerwolf dagboek [[A]]",
        "Weerwolfbende [[A | deel 10]]",
        "Weerwolfgeheimen [[A]]",
        "Weerwolfnachtbaan [[A | deel 12]]",
        "Weerwolvenbos [[B]]",
        "Weerwolvenfeest [[A]]",
        "Weerwolvenfeest [[E4 | AVI]]",
        "Weerwolvensoep [[A]]",
      ]
    end

    it 'allows options hash as filter' do
      options = { title_cont: 'weerwol' }
      expect(described_class.enriched_titles(options)).to eq described_class.enriched_titles(title_cont: 'weerwol')
    end
  end

end
