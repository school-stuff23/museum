require "./lib/patron"

RSpec.describe Patron do
  let(:patron_1) { Patron.new("Bob", 20) }

  context "Instantiation" do
    describe "#initialize" do
      it "can instantiate a new Patron object" do
        expect(patron_1).to be_a Patron
      end
    end

    describe "#name" do
      it "has a name and a way to read that data" do 
        expect(patron_1.name).to eq("Bob")
      end
    end

    describe "#spending_money" do
      it "has spending_money and a way to read that data" do
        expect(patron_1.spending_money).to be 20
      end
    end

    describe "#interests" do
      it "starts with no interests" do
        expect(patron_1.interests).to be_an Array
        expect(patron_1.interests).to be_empty
      end
    end

    describe "#add_interest" do
      it "can add interests" do 
        patron_1.add_interest("Dead Sea Scrolls")
        patron_1.add_interest("Gems and Minerals")

        expect(patron_1.interests).to match(["Dead Sea Scrolls", "Gems and Minerals"])
      end
    end
  end
end