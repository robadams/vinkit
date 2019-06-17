require "spec_helper"

describe Vinkit::Decoder do
  let(:vin) { '1GCWG9CL8C1167771' } 
  subject(:decoder) { described_class.new(vin) }

  [:year, :make, :model].each do |k|
    it 'raises not implemented' do
      expect { decoder.send(k) }.to raise_error(Vinkit::Adapters::NotImplementedError, /#{k}/)
    end
  end

  shared_examples :decodes do |vin, adapter|
    subject(:decoder) { described_class.new(vin, adapter: adapter) }

    {
      vin: '1GCWG9CL8C1167771',
      year: '2012',
      make: 'Chevrolet',
      model: 'Express'
    }.each do |k, v|
      it "decodes correct #{k}" do
        expect(decoder.send(k)).to eq(v)
      end
    end
  end

  context 'with Test adapter' do
    include_examples :decodes, '1GCWG9CL8C1167771', Vinkit::Adapters::Test
  end

  context 'with Nhtsa adapter', network: false do
    include_examples :decodes, '1GCWG9CL8C1167771', Vinkit::Adapters::Nhtsa

    it "handles payload error"

    it "handles response error"
  end
end
