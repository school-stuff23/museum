require "./lib/museum"
require "./lib/patron"
require "./lib/exhibit"

RSpec.describe Museum do 
  let(:dmns) { Museum.new("Denver Museum of Nature and Science") }

  context "Instantiation" do
    describe "#initialize" do
      it "can instantiate a new Museum object" do 
        expect(dmns).to be_a Museum
      end
    end

    describe "#name" do
      it "has a name and a way to read that data" do
        expect(dmns.name).to eq("Denver Museum of Nature and Science")
      end
    end

    describe "#exhibits" do
      it "starts with no exhibits" do 
        expect(dmns.exhibits).to be_an Array
        expect(dmns.exhibits).to be_empty
      end
    end
  end

  context "Museums, Patrons, and Exhibits" do
    let(:gems_and_minerals) { Exhibit.new({ name: "Gems and Minerals", cost: 0 }) }
    let(:dead_sea_scrolls) { Exhibit.new({ name: "Dead Sea Scrolls", cost: 10 }) }
    let(:imax) { Exhibit.new({ name: "IMAX", cost: 15 }) }

    let(:patron_1) { Patron.new("Bob", 20) }
    let(:patron_2) { Patron.new("Sally", 20) }
    let(:patron_3) { Patron.new("Johnny", 5) }

    describe "#add_exhibit" do
      it "can add exhibits" do
        dmns.add_exhibit(gems_and_minerals)
        dmns.add_exhibit(dead_sea_scrolls)
        dmns.add_exhibit(imax)

        expect(dmns.exhibits).to match([gems_and_minerals, dead_sea_scrolls, imax])
      end
    end

    describe "#recommend_exhibits" do
      it "should recommend exhibits that match a Patron's interests" do
        dmns.add_exhibit(gems_and_minerals)
        dmns.add_exhibit(dead_sea_scrolls)
        dmns.add_exhibit(imax)

        patron_1.add_interest("Dead Sea Scrolls")
        patron_1.add_interest("Gems and Minerals")
        patron_2.add_interest("IMAX")

        expect(dmns.recommend_exhibits(patron_1)).to match([gems_and_minerals, dead_sea_scrolls])
        expect(dmns.recommend_exhibits(patron_2)).to match([imax])
      end
    end

    describe "#patrons" do
      it "starts with no patrons" do 
        dmns.add_exhibit(gems_and_minerals)
        dmns.add_exhibit(dead_sea_scrolls)
        dmns.add_exhibit(imax)

        expect(dmns.patrons).to be_empty
        expect(dmns.patrons).to be_an Array
      end
    end

    context "Patron with 0 spending money" do
      let(:patron_1) { Patron.new("Bob", 0) }

      describe "#admit" do
        it "can admit patrons" do 
          dmns.add_exhibit(gems_and_minerals)
          dmns.add_exhibit(dead_sea_scrolls)
          dmns.add_exhibit(imax)

          patron_1.add_interest("Gems and Minerals")
          patron_1.add_interest("Dead Sea Scrolls")
          patron_2.add_interest("Dead Sea Scrolls")
          patron_3.add_interest("Dead Sea Scrolls")

          dmns.admit(patron_1)
          dmns.admit(patron_2)
          dmns.admit(patron_3)

          expect(dmns.patrons).to match([patron_1, patron_2, patron_3])
        end
      end

      describe "#patrons_by_exhibit_interest" do
        it "returns a hash with Exhibit keys and an Array of Patrons as the value" do 
          dmns.add_exhibit(gems_and_minerals)
          dmns.add_exhibit(dead_sea_scrolls)
          dmns.add_exhibit(imax)

          patron_1.add_interest("Gems and Minerals")
          patron_1.add_interest("Dead Sea Scrolls")
          patron_2.add_interest("Dead Sea Scrolls")
          patron_3.add_interest("Dead Sea Scrolls")

          dmns.admit(patron_1)
          dmns.admit(patron_2)
          dmns.admit(patron_3)

          expected = {
            gems_and_minerals => [patron_1],
            dead_sea_scrolls => [patron_1, patron_2, patron_3],
            imax => []
          }

          expect(dmns.patrons_by_exhibit_interest).to match(expected)
          expect(dmns.patrons_by_exhibit_interest.keys).to all be_an Exhibit
        end
      end

      describe "#ticket_lottery_contestants" do
        it "returns an array of patrons that do not have enough money to see an exhibit, but are interested in that exhibit" do 
          dmns.add_exhibit(gems_and_minerals)
          dmns.add_exhibit(dead_sea_scrolls)
          dmns.add_exhibit(imax)

          patron_1.add_interest("Gems and Minerals")
          patron_1.add_interest("Dead Sea Scrolls")
          patron_2.add_interest("Dead Sea Scrolls")
          patron_3.add_interest("Dead Sea Scrolls")

          dmns.admit(patron_1)
          dmns.admit(patron_2)
          dmns.admit(patron_3)

          expect(dmns.ticket_lottery_contestants(dead_sea_scrolls)).to match([patron_1, patron_3])
        end
      end

      describe "#draw_lottery_winner" do
        it "returns a random winner based on the available contestants for an exhibit" do 
          dmns.add_exhibit(gems_and_minerals)
          dmns.add_exhibit(dead_sea_scrolls)
          dmns.add_exhibit(imax)

          patron_1.add_interest("Gems and Minerals")
          patron_1.add_interest("Dead Sea Scrolls")
          patron_2.add_interest("Dead Sea Scrolls")
          patron_3.add_interest("Dead Sea Scrolls")

          dmns.admit(patron_1)
          dmns.admit(patron_2)
          dmns.admit(patron_3)

          expect(dmns.draw_lottery_winner(dead_sea_scrolls)).to eq("Bob").or eq("Johnny")
          expect(dmns.draw_lottery_winner(gems_and_minerals)).to be_nil
        end
      end

      describe "#announce_lottery_winner" do
        it "returns a String announcing the lottery winner for the exhibit" do 
          dmns.add_exhibit(gems_and_minerals)
          dmns.add_exhibit(dead_sea_scrolls)
          dmns.add_exhibit(imax)

          patron_1.add_interest("Gems and Minerals")
          patron_1.add_interest("Dead Sea Scrolls")
          patron_2.add_interest("Dead Sea Scrolls")
          patron_3.add_interest("Dead Sea Scrolls")

          dmns.admit(patron_1)
          dmns.admit(patron_2)
          dmns.admit(patron_3)

          allow(dmns).to receive(:draw_lottery_winner).and_return("Bob")
          expect(dmns.announce_lottery_winner(imax)).to eq("Bob has won the IMAX exhibit lottery")

          allow(dmns).to receive(:draw_lottery_winner).and_return(nil)
          expect(dmns.announce_lottery_winner(gems_and_minerals)).to eq("No winners for this lottery")
        end
      end

      describe "#attend_exhibits" do
        it "" do
          dmns.add_exhibit(gems_and_minerals)
          dmns.add_exhibit(dead_sea_scrolls)
          dmns.add_exhibit(imax)

          patron_1.add_interest("Gems and Minerals")
          patron_1.add_interest("Dead Sea Scrolls")
          patron_2.add_interest("Dead Sea Scrolls")
          patron_3.add_interest("Dead Sea Scrolls")

          dmns.admit(patron_1)
          dmns.admit(patron_2)
          dmns.admit(patron_3)

          # expect(dmns.attend_exhibits(patron_2)).to receive(:patrons_by_exhibit_interest)
        end
      end

      describe "#patrons_of_exhibits" do
        it "returns a Hash where the keys are the exhibits and the values are Arrays containing all the Patrons that attended that Exhibit" do
          dmns.add_exhibit(gems_and_minerals) # 0
          dmns.add_exhibit(dead_sea_scrolls) # 10
          dmns.add_exhibit(imax) # 15

          patron_1.add_interest("Gems and Minerals")
          patron_1.add_interest("Dead Sea Scrolls")
          patron_2.add_interest("Dead Sea Scrolls")
          patron_3.add_interest("Dead Sea Scrolls")

          dmns.admit(patron_1) # 0
          dmns.admit(patron_2) # 20
          dmns.admit(patron_3) # 5

          expected = {
            gems_and_minerals => [patron_1],
            dead_sea_scrolls => [patron_2],
            imax => []
          }

          expect(dmns.patrons_of_exhibits).to match(expected)
        end
      end

      describe "#revenue" do
        it "returns an Integer representing the revenue collected from Patrons attending Exhibits" do
          dmns.add_exhibit(gems_and_minerals) # 0
          dmns.add_exhibit(dead_sea_scrolls) # 10
          dmns.add_exhibit(imax) # 15

          patron_4 = Patron.new("Abdul", 50)

          patron_1.add_interest("Gems and Minerals")
          patron_1.add_interest("Dead Sea Scrolls")
          patron_2.add_interest("Dead Sea Scrolls")
          patron_3.add_interest("Dead Sea Scrolls")
          patron_4.add_interest("Dead Sea Scrolls")
          patron_4.add_interest("Gems and Minerals")
          patron_4.add_interest("IMAX")
          
          expect(dmns.revenue).to be 0

          dmns.admit(patron_1) # 0
          dmns.admit(patron_2) # 20
          dmns.admit(patron_3) # 5
          
          expect(dmns.revenue).to be 10
          
          dmns.admit(patron_4) # 50

          expect(dmns.revenue).to be 35

          # expected = {
          #   gems_and_minerals => [patron_1, patron_4], # $0 x 2 = 0
          #   dead_sea_scrolls => [patron_2, patron_4], # $10 x 2 = 20
          #   imax => [patron_4] # $15 x 1 = 15
          # }

        end
      end
    end
  end

  # describe "Iteration 4" do 

  # end
end