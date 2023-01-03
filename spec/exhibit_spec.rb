require "./lib/exhibit"

RSpec.describe Exhibit do
  let(:exhibit) { Exhibit.new({ name: "Gems and Minerals", cost: 0 }) }

  context "Instantiation" do
    describe "#initialize" do
      it "can instantiate a new Exhibit object" do
        expect(exhibit).to be_an Exhibit
      end
    end

    describe "#name" do
      it "has a name and a way to read that data" do
        expect(exhibit.name).to eq("Gems and Minerals")
      end
    end

    describe "#cost" do
      it "has a cost and a way to read that data" do
        expect(exhibit.cost).to be_zero
      end
    end
  end
end
