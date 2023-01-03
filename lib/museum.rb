class Museum 
  attr_reader :name,
              :exhibits,
              :patrons,
              :revenue

  def initialize(name)
    @name = name 
    @exhibits = []
    @patrons = []
    @revenue = 0
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit 
  end

  def recommend_exhibits(patron)
    @exhibits.select do |exhibit|
      patron.interests.include?(exhibit.name)
    end
  end

  def admit(patron)
    @patrons << patron 
  end

  def patrons_by_exhibit_interest
    @exhibits.reduce({}) do |hash, exhibit|
      hash[exhibit] = interested_patrons_for(exhibit)
      hash
    end

    # by_interest = {}

    # @exhibits.each do |exhibit|
    #   by_interest[exhibit] = interested_patrons(exhibit)
    # end
    
    # by_interest
  end

  def interested_patrons_for(exhibit)
    @patrons.select do |patron|
      patron.interests.include?(exhibit.name) 
    end
  end

  def ticket_lottery_contestants(exhibit)
    interested_patrons = interested_patrons_for(exhibit)
    interested_patrons.select do |patron|
      patron.spending_money < exhibit.cost 
    end
  end

  def draw_lottery_winner(exhibit)
    contestants = ticket_lottery_contestants(exhibit)
    return nil if contestants.empty?
    winner = contestants.sample
    winner.name 
  end

  def announce_lottery_winner(exhibit)
    winner = draw_lottery_winner(exhibit)
    winner.nil? ?
      "No winners for this lottery" :
      "#{winner} has won the #{exhibit.name} exhibit lottery"
  end

  # def attend_exhibits(patron)
  #   recommended_exhibits = recommend_exhibits(patron).sort_by(&:cost).reverse
  #   require 'pry'; binding.pry
    
  #   recommended_exhibits.each do |e|
  #     if patron.spending_money >= e.cost
  #       @revenue += e.cost
  #       patron.spending_money -= e.cost
  #     end
  #   end
  # end
  
  def patrons_of_exhibits
    exhibit_visitors = {}

    sorted = patrons_by_exhibit_interest.sort_by { |k, v| -k.cost }

    sorted.each do |pair|
      exhibit = pair[0]
      patrons = pair[1]
      
      exhibit_visitors[exhibit] = []
      
      patrons.each do |patron|
        if patron.spending_money >= exhibit.cost
          exhibit_visitors[exhibit] << patron

          patron.spending_money -= exhibit.cost
          @revenue += exhibit.cost
        end
      end
    end
    
    exhibit_visitors
  end
end