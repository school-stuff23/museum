class Exhibit 
  attr_reader :name,
              :cost

  def initialize(data)
    @name = data[:name]
    @cost = data[:cost]
  end
end