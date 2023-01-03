require 'rspec'
require 'simplecov'
SimpleCov.start
require '../lib/exhibit.rb'
require '../lib/patron'
require '../lib/museum'

RSpec.configure do |config|
  config.default_formatter = 'doc'
  config.mock_with :mocha
end

RSpec.describe 'museum spec' do
  before :each do
    @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 0})
    @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    @imax = Exhibit.new({name: "IMAX", cost: 15})
    @bob = Patron.new("Bob", 20)
    @sally = Patron.new("Sally", 20)
    @dmns = Museum.new("Denver Museum of Nature and Science")
  end

  describe 'Iteration 1' do
    it '1. Exhibit & Patron Creation' do
      expect(Exhibit).to respond_to(:new).with(1).argument
      expect(@dead_sea_scrolls).to be_an_instance_of(Exhibit)
      expect(@dead_sea_scrolls).to respond_to(:name).with(0).argument
      expect(@dead_sea_scrolls.name).to eq('Dead Sea Scrolls')
      expect(@dead_sea_scrolls).to respond_to(:cost).with(0).argument
      expect(@dead_sea_scrolls.cost).to eq(0)
      expect(Patron).to respond_to(:new).with(2).argument
      expect(@bob).to be_an_instance_of(Patron)
      expect(@bob).to respond_to(:name).with(0).argument
      expect(@bob.name).to eq('Bob')
      expect(@bob).to respond_to(:spending_money).with(0).argument
      expect(@bob.spending_money).to eq(20)
      expect(@bob).to respond_to(:interests).with(0).argument
      expect(@bob.interests).to eq([])
    end

    it '2. Patron #add_interest' do
      expect(@bob).to respond_to(:add_interest).with(1).argument
      @bob.add_interest("Dead Sea Scrolls")
      @bob.add_interest("Gems and Minerals")
      expect(@bob.interests).to eq(["Dead Sea Scrolls", "Gems and Minerals"])
    end
  end

  describe 'Iteration 2' do
    before :each do
      @bob.add_interest("Dead Sea Scrolls")
      @bob.add_interest("Gems and Minerals")
      @sally.add_interest("IMAX")
    end

    it '3. Museum ::new' do
      expect(Museum).to respond_to(:new).with(1).argument
      expect(@dmns).to be_an_instance_of(Museum)
      expect(@dmns).to respond_to(:name).with(0).argument
      expect(@dmns.name).to eq('Denver Museum of Nature and Science')
      expect(@dmns).to respond_to(:exhibits).with(0).argument
      expect(@dmns.exhibits).to eq([])
    end

    it '4. Museum #add_exhibit' do
      expect(@dmns).to respond_to(:add_exhibit).with(1).argument
      @dmns.add_exhibit(@dead_sea_scrolls)
      @dmns.add_exhibit(@gems_and_minerals)
      expect(@dmns.exhibits).to eq([@dead_sea_scrolls, @gems_and_minerals])
    end

    it '5. Museum #recommend_exhibits' do
      @dmns.add_exhibit(@dead_sea_scrolls)
      @dmns.add_exhibit(@gems_and_minerals)
      @dmns.add_exhibit(@imax)
      expect(@dmns).to respond_to(:recommend_exhibits).with(1).argument
      expect(@dmns.recommend_exhibits(@bob)).to eq([@dead_sea_scrolls, @gems_and_minerals])
      expect(@dmns.recommend_exhibits(@sally)).to eq([@imax])
    end
  end

  describe 'Iteration 3' do
    before :each do
      @imax_2 = Exhibit.new({name: "IMAX2",cost: 15})
      @dmns.add_exhibit(@dead_sea_scrolls)
      @dmns.add_exhibit(@gems_and_minerals)
      @dmns.add_exhibit(@imax)
      @tj = Patron.new("TJ", 7)
      @gabe = Patron.new("Gabe", 10)
      @morgan = Patron.new("Morgan", 15)
      @tj.add_interest("IMAX")
      @tj.add_interest("Dead Sea Scrolls")
      @gabe.add_interest("Dead Sea Scrolls")
      @gabe.add_interest("IMAX")
      @morgan.add_interest("Gems and Minerals")
      @morgan.add_interest("Dead Sea Scrolls")
      @bob.add_interest("Dead Sea Scrolls")
      @bob.add_interest("Gems and Minerals")
      @sally.add_interest("Dead Sea Scrolls")
    end

    it '6. Museum #patrons' do
      expect(@dmns).to respond_to(:patrons).with(0).argument
      expect(@dmns.patrons).to eq([])
    end

    it '7. Museum #admit' do
      expect(@dmns).to respond_to(:admit).with(1).argument
      @dmns.admit(@bob)
      @dmns.admit(@sally)
      expect(@dmns.patrons).to eq([@bob, @sally])
    end

    it '8. Museum #patrons_by_exhibit_interest' do
      @dmns.admit(@bob)
      @dmns.admit(@sally)
      expected = {
        @dead_sea_scrolls => [@bob, @sally],
        @gems_and_minerals => [@bob],
        @imax => [],
      }
      expect(@dmns).to respond_to(:patrons_by_exhibit_interest).with(0).argument
      expect(@dmns.patrons_by_exhibit_interest).to eq(expected)
    end

      it '9. Museum #ticket_lottery_contestants' do
        @dmns.add_exhibit(@imax_2)
        @tj.add_interest("IMAX2")
        @gabe.add_interest("IMAX2")
        @dmns.admit(@tj)
        @dmns.admit(@gabe)
        @dmns.admit(@morgan)

        expected = [@tj, @gabe]
        expect(@dmns).to respond_to(:ticket_lottery_contestants).with(1).argument
        expect(@dmns.ticket_lottery_contestants(@imax_2)).to eq(expected)
      end

      it '10. Museum #draw_lottery_winner' do
        @dmns.add_exhibit(@imax_2)
        @tj.add_interest("IMAX2")
        @gabe.add_interest("IMAX2")
        @dmns.admit(@tj)
        @dmns.admit(@gabe)
        @dmns.admit(@morgan)

        expect(@dmns).to respond_to(:draw_lottery_winner).with(1).argument
        expect(@dmns.draw_lottery_winner(@imax_2)).to eq("TJ").or(eq("Gabe"))
      end

      it '11. Museum #announce_lottery_winner' do
        @dmns.add_exhibit(@imax_2)
        @tj.add_interest("IMAX2")
        @gabe.add_interest("IMAX2")
        @dmns.admit(@tj)
        @dmns.admit(@gabe)
        @dmns.admit(@morgan)
        @dmns.stubs(:draw_lottery_winner).returns('Gabe')
        expected = "Gabe has won the IMAX2 exhibit lottery"
        expect(@dmns).to respond_to(:announce_lottery_winner).with(1).argument
        expect(@dmns.announce_lottery_winner(@imax_2)).to eq(expected)
      end
  end

  describe 'Iteration 4' do
    before :each do
      @dmns = Museum.new("Denver Museum of Nature and Science")
      @gems_and_minerals = Exhibit.new({name: "Gems and Minerals",cost: 0})
      @imax = Exhibit.new({name: "IMAX", cost: 15})
      @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls",cost:  10})
      @dmns.add_exhibit(@gems_and_minerals)
      @dmns.add_exhibit(@imax)
      @dmns.add_exhibit(@dead_sea_scrolls)

      # Interested in two exhibits but none in price range
      @tj = Patron.new("TJ", 7)
      @tj.add_interest("IMAX")
      @tj.add_interest("Dead Sea Scrolls")
      @dmns.admit(@tj)

      # Interested in two exhibits and only one is in price range
      @bob = Patron.new("Bob", 10)
      @bob.add_interest("Dead Sea Scrolls")
      @bob.add_interest("IMAX")
      @dmns.admit(@bob)

      # Interested in two exhibits and both are in price range, but can only afford one
      @sally = Patron.new("Sally", 20)
      @sally.add_interest("IMAX")
      @sally.add_interest("Dead Sea Scrolls")
      @dmns.admit(@sally)

      # Interested in two exhibits and both are in price range, and can afford both
      @morgan = Patron.new("Morgan", 15)
      @morgan.add_interest("Gems and Minerals")
      @morgan.add_interest("Dead Sea Scrolls")
      @dmns.admit(@morgan)
    end

    it '12. Museum #patrons_of_exhibits' do
      expected = {
        @gems_and_minerals => [@morgan],
        @dead_sea_scrolls => [@bob, @morgan],
        @imax => [@sally]
      }

      expect(@dmns).to respond_to(:patrons_of_exhibits).with(0).argument
      expect(@dmns.patrons_of_exhibits).to eq(expected)
    end

    it '13. Museum #admit reduces spending money' do
      expect(@tj.spending_money).to eq(7)
      expect(@bob.spending_money).to eq(0)
      expect(@sally.spending_money).to eq(5)
      expect(@morgan.spending_money).to eq(5)
    end

    it '14. Museum #revenue' do
      expect(@dmns).to respond_to(:revenue).with(0).argument
      expect(@dmns.revenue).to eq(35)
    end
  end
end