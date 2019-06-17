require "spec_helper"

describe Vinkit::Decoder do
  let(:vin) { '1GCWG9CL8C1167771' } 
  subject(:decoder) { described_class.new(vin) }

  [:year, :make, :model].each do |k|
    it 'raises not implemented' do
      expect { decoder.send(k) }.to raise_error(Vinkit::Adapters::NotImplementedError, /#{k}/)
    end
  end

  context 'with Test adapter' do
      subject(:decoder) { described_class.new(vin, adapter: Vinkit::Adapters::Test) }

      it 'decodes correct year' do
        expect(decoder.year).to eq('2012')
      end

      it 'decodes correct make' do
        expect(decoder.make).to eq('Chevrolet')
      end

      it 'decodes correct model' do
        expect(decoder.model).to eq('Express')
      end
  end
end
