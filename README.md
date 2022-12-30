# Museum

## Instructions

* Fork this Repository
* Clone your forked repo to your computer.
* Complete the activity below.
* COMMIT YOUR TESTS FIRST! We will check for TDD via your git history.
* Push your solution to your forked repo
* Submit a pull request from your repository to this repository
* Put your name in your PR!

### Iteration 1

Use TDD to create an `Exhibit` and a `Patron` class that respond to the following interaction pattern:

```ruby
pry(main)> require './lib/exhibit'
# => true

pry(main)> require './lib/patron'
# => true

pry(main)> exhibit = Exhibit.new({name: "Gems and Minerals", cost: 0})
# => #<Exhibit:0x00007fcb13bd22d0...>

pry(main)> exhibit.name
# => "Gems and Minerals"

pry(main)> exhibit.cost
# => 0

pry(main)> patron_1 = Patron.new("Bob", 20)
# => #<Patron:0x00007fcb13b5c7d8...>

pry(main)> patron_1.name
# => "Bob"

pry(main)> patron_1.spending_money
# => 20

pry(main)> patron_1.interests
# => []

pry(main)> patron_1.add_interest("Dead Sea Scrolls")

pry(main)> patron_1.add_interest("Gems and Minerals")

pry(main)> patron_1.interests
# => ["Dead Sea Scrolls", "Gems and Minerals"]
```

## Iteration 2

Use TDD to create a `Museum` class that responds to the following interaction pattern. For the `recommend_exhibits` method, the `Museum` should recommend exhibits that match a `Patron`'s interests.

```ruby
pry(main)> require './lib/museum'
# => true

pry(main)> require './lib/patron'
# => true

pry(main)> require './lib/exhibit'
# => true

pry(main)> dmns = Museum.new("Denver Museum of Nature and Science")
# => #<Museum:0x00007fb400a6b0b0...>

pry(main)> dmns.name
# => "Denver Museum of Nature and Science"

pry(main)> dmns.exhibits
# => []

pry(main)> gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
# => #<Exhibit:0x00007fb400bbcdd8...>

pry(main)> dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
# => #<Exhibit:0x00007fb400b851f8...>

pry(main)> imax = Exhibit.new({name: "IMAX",cost: 15})
# => #<Exhibit:0x00007fb400acc590...>

pry(main)> dmns.add_exhibit(gems_and_minerals)

pry(main)> dmns.add_exhibit(dead_sea_scrolls)

pry(main)> dmns.add_exhibit(imax)

pry(main)> dmns.exhibits
# => [#<Exhibit:0x00007fb400bbcdd8...>, #<Exhibit:0x00007fb400b851f8...>, #<Exhibit:0x00007fb400acc590...>]

pry(main)> patron_1 = Patron.new("Bob", 20)
# => #<Patron:0x00007fb400a51cc8...>

pry(main)> patron_1.add_interest("Dead Sea Scrolls")

pry(main)> patron_1.add_interest("Gems and Minerals")

pry(main)> patron_2 = Patron.new("Sally", 20)
# => #<Patron:0x00007fb400036338...>

pry(main)> patron_2.add_interest("IMAX")

pry(main)> dmns.recommend_exhibits(patron_1)
# => [#<Exhibit:0x00007fb400bbcdd8...>, #<Exhibit:0x00007fb400b851f8...>]

pry(main)> dmns.recommend_exhibits(patron_2)
# => [#<Exhibit:0x00007fb400acc590...>]
```

## Iteration 3

- Use TDD to update your `Museum` class so that it responds to the following interaction pattern.
- For `patrons_by_exhibit_interest`, this method takes no arguments and returns a Hash where each key is an Exhibit. The value associated with that Exhibit is an Array of all the Patrons that have an interest in that exhibit.
- `ticket_lottery_contestants` returns an array of patrons that do not have enough money to see an exhibit, but are interested in that exhibit. The lottery winner is generated randomly based on the available contestants when `draw_lottery_winner` is called.
- You will need to use a **stub** to test the `announce_lottery_winner` method in conjunction with the `draw_lottery_winner` method. JOY!

```ruby
pry(main)> require './lib/museum'
# => true

pry(main)> require './lib/patron'
# => true

pry(main)> require './lib/exhibit'
# => true

pry(main)> dmns = Museum.new("Denver Museum of Nature and Science")
# => #<Museum:0x00007fb20205d690...>

pry(main)> gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
# => #<Exhibit:0x00007fb202238618...>

pry(main)> dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
# => #<Exhibit:0x00007fb202248748...>

pry(main)> imax = Exhibit.new({name: "IMAX",cost: 15})
# => #<Exhibit:0x00007fb20225f8d0...>

pry(main)> dmns.add_exhibit(gems_and_minerals)

pry(main)> dmns.add_exhibit(dead_sea_scrolls)

pry(main)> dmns.add_exhibit(imax)

pry(main)> dmns.patrons
# => []

pry(main)> patron_1 = Patron.new("Bob", 0)
# => #<Patron:0x00007fb2011455b8...>

pry(main)> patron_1.add_interest("Gems and Minerals")

pry(main)>
patron_1.add_interest("Dead Sea Scrolls")

pry(main)> patron_2 = Patron.new("Sally", 20)
# => #<Patron:0x00007fb20227f8b0...>

pry(main)> patron_2.add_interest("Dead Sea Scrolls")

pry(main)> patron_3 = Patron.new("Johnny", 5)
# => #<Patron:0x6666fb20114megan...>

pry(main)> patron_3.add_interest("Dead Sea Scrolls")

pry(main)> dmns.admit(patron_1)

pry(main)> dmns.admit(patron_2)

pry(main)> dmns.admit(patron_3)

pry(main)> dmns.patrons
# => [#<Patron:0x00007fb2011455b8...>, #<Patron:0x00007fb20227f8b0...>, #<Patron:0x6666fb20114megan...>]

#Patrons are added even if they don't have enough money for all/any exhibits.

pry(main)> dmns.patrons_by_exhibit_interest
# =>
# {
#   #<Exhibit:0x00007fb202238618...> => [#<Patron:0x00007fb2011455b8...>],
#   #<Exhibit:0x00007fb202248748...> => [#<Patron:0x00007fb2011455b8...>, #<Patron:0x00007fb20227f8b0...>, #<Patron:0x6666fb20114megan...>],
#   #<Exhibit:0x00007fb20225f8d0...> => []
# }

pry(main)> dmns.ticket_lottery_contestants(dead_sea_scrolls)
# => [#<Patron:0x00007fb2011455b8...>, #<Patron:0x6666fb20114megan...>]

pry(main)> dmns.draw_lottery_winner(dead_sea_scrolls)
# => "Johnny" or "Bob" can be returned here. Fun!

pry(main)> dmns.draw_lottery_winner(gems_and_minerals)
# => nil

#If no contestants are elgible for the lottery, nil is returned.

pry(main)> dmns.announce_lottery_winner(imax)
# => "Bob has won the IMAX edhibit lottery"

# The above string should match exactly, you will need to stub the return of `draw_lottery_winner` as the above method should depend on the return value of `draw_lottery_winner`.

pry(main)> dmns.announce_lottery_winner(gems_and_minerals)
# => "No winners for this lottery"

# If there are no contestants, there are no winners.
```

## Iteration 4

Use TDD to update your `Museum` class to add the following functionality:

* When a `Patron` is admitted to the `Museum`, they attend `Exhibits`. The `Exhibits` that a `Patron` attends follows these rules:
* A Patron will only attend `Exhibits` they are interested in
* A Patron will attend an `Exhibit` with a higher cost before an `Exhibit` with a lower cost.
* If a `Patron` does not have enough `spending_money` to cover the cost of the `Exhbit`, they will not attend the `Exhibit`.
* When the Patron attends an `Exhibit`, the cost of the `Exhibit` should be subtracted from their `spending_money` and added to the `Museum` revenue.
* A `Museum` should have a `patrons_of_exhibits` method that returns a Hash where the keys are the exhibits and the values are Arrays containing all the `Patrons` that attended that `Exhibit`.
* A `Museum` should have a method `revenue` that returns an Integer representing the revenue collected from `Patrons` attending `Exhibits`.
