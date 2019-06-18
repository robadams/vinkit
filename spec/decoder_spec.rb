require "spec_helper"

describe Vinkit::Decoder do
  CAR = {
    vin: "1GCWG9CL8C1167771",
    year: "2012",
    make: "Chevrolet",
    model: "Express"
  }.freeze
  let(:vin) { CAR.fetch(:vin) } 

  subject(:decoder) { described_class.new(vin) }

  it "returns vin" do
    expect(decoder.vin).to eq(vin)
  end

  [:year, :make, :model].each do |k|
    it "raises not implemented" do
      expect { decoder.send(k) }.to raise_error(Vinkit::Adapters::NotImplementedError, /#{k}/)
    end
  end

  shared_examples :decodes do |vin, adapter|
    subject(:decoder) { described_class.new(vin, adapter: adapter) }

    CAR.each do |k, v|
      it "decodes correct #{k}" do
        expect(decoder.send(k)).to eq(v)
      end
    end
  end

  shared_examples :error do |vin, adapter, message|
    subject(:decoder) { described_class.new(vin, adapter: adapter) }

    it "raises error" do
      expect { decoder.year }.to raise_error(Vinkit::Adapters::Error, /#{message}/)
    end
  end

  context "with Test adapter" do
    it_behaves_like :decodes, "1GCWG9CL8C1167771", Vinkit::Adapters::Test
  end

  context "with Nhtsa adapter", network: false do
    it_behaves_like :decodes, "1GCWG9CL8C1167771", Vinkit::Adapters::Nhtsa

    context "with decoding error" do
      it_behaves_like :error, "abc", Vinkit::Adapters::Nhtsa, "decoding"
    end

    context "with response errors" do
      let(:response) { Struct.new(:status, :body).new(200, '') }

      before do
        allow(Faraday)
          .to receive(:get)
          .and_return(response)
      end

      context "with payload error" do
        it_behaves_like :error, "1GCWG9CL8C1167771", Vinkit::Adapters::Nhtsa, "unexpected token"
      end

      context "with status error" do
        let(:response) { Struct.new(:status, :body).new(404, '') }

        it_behaves_like :error, "1GCWG9CL8C1167771", Vinkit::Adapters::Nhtsa, "404"
      end
    end
  end
end
