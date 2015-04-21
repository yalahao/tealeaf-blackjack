CLUB = "\u2664 ".encode('utf-8')
HEART = "\u2661 ".encode('utf-8')
SPADE = "\u2667 ".encode('utf-8')
DIAMOND= "\u2662 ".encode('utf-8')
RANKS = %w{A 2 3 4 5 6 7 8 9 J Q K}
NUMBER_OF_DECKS = 2

def say(s)
  puts "--- #{s} ---"
end

def new_deck
  deck = {CLUB => [ ], HEART => [ ], SPADE => [ ], DIAMOND => [ ]}
  deck_number = 0
  while deck_number < NUMBER_OF_DECKS
    [CLUB, HEART, SPADE, DIAMOND].each do |suit|
      deck[suit].concat(RANKS)
    end
    deck_number +=1
  end
  deck
end

def show(hand)
  [CLUB, HEART, SPADE, DIAMOND].each do |suit|
    say "#{suit}: #{hand[suit]}" if !hand[suit].empty?
  end
end

def show_player(hand)
  say "Your hand is:"
  show(hand)
  say "Your hand sums up to #{sum(hand)}"
end

def show_dealer(hand)
  say "Dealer's hand is:"
  show(hand)
  say "Dealer's hand sums up to #{sum(hand)}"
end

def new_game

  deck = new_deck
  player_hand = {CLUB => [ ], HEART => [ ], SPADE => [ ], DIAMOND => [ ]}
  dealer_hand = {CLUB => [ ], HEART => [ ], SPADE => [ ], DIAMOND => [ ]}

  2.times {hit(player_hand, deck)}
  2.times {hit(dealer_hand, deck)}

  show_player(player_hand)
  show_dealer(dealer_hand)

  player_turn(player_hand, deck)
  dealer_turn(dealer_hand, deck)

  check_winner(player_hand, dealer_hand)
  play_again

end

def hit(hand, deck)
  suit = deck.keys.sample
  rank = deck[suit].sample
  if rank
    deck[suit].delete(rank)
    hand[suit] << rank
    return
  else
    hit(hand, deck)
  end
end

def sum(hand)
  total = 0
  [CLUB, HEART, SPADE, DIAMOND].each do |suit|
    hand[suit].each do |rank|
      if rank == 'A'
        total += 11
      elsif ['J','Q','K'].include?(rank)
        total += 10
      else
        total += rank.to_i
      end
    end
  end
  # Adjust for aces
  if total > 21
    [CLUB, HEART, SPADE, DIAMOND].each do |suit|
      hand[suit].select{|r| r == "A"}.count.times do
        total -= 10 if s > 21
      end
    end
  end
  total
end


def player_turn(hand, deck)
  if sum(hand) > 21
    say "You're busted!"
    play_again
  elsif sum(hand) == 21
    say "Blackjack! You won!"
    play_again
  else
    say "Hit or Stay?"
    choice = gets.chomp.downcase
    if choice == "hit"
      hit(hand,deck)
      show_player(hand)
      player_turn(hand,deck)
    elsif choice == "stay"
      return
    else
      say "Invalid choice. Try again."
      player_turn(hand,deck)
    end
  end
end

def dealer_turn(hand, deck)
  if sum(hand) < 17
    hit(hand,deck)
    say "Dealer hits"
    show_dealer(hand)
    dealer_turn(hand,deck)
  elsif sum(hand) > 21
    say "Dealer is busted. You won!"
    play_again
  elsif sum(hand) == 21
    say "Dealer hit Blackjack. You lose.."
  else
    say "Dealer stays"
  end
end

def check_winner(player_hand, dealer_hand)
  if sum(player_hand) > sum(dealer_hand)
    say "You won!"
  elsif sum(player_hand) == sum(dealer_hand)
    say "It's a tie."
  else
    say "You lose..."
  end
end

def play_again
  say "Play again? (Y/N)"
  choice = gets.chomp.downcase
  if choice == 'y'
    new_game
  elsif choice == 'n'
    say "See you next time!"
    abort
  else
    say "Invalid choice. Try again."
    play_again
  end
end

new_game
