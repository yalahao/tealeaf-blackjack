# First attempt before watching solution video
# Logic
=begin

Keep track of
  Deck
  Player_hand
    Display(hand)
  Dealer_hand

Each card has
  Rank
  Suit

Game
  Initial_round
    Deal 2 cards for each
  Round
    Choose Hit or Stay
    Deal if Hit
    Check score
    Switch player
  Win
    Announce winner
    Play_again?
    End game

=end

require 'pry'

CLUB = "\u2664 ".encode('utf-8')
HEART = "\u2661 ".encode('utf-8')
SPADE = "\u2667 ".encode('utf-8')
DIAMOND= "\u2662 ".encode('utf-8')
RANKS = ['A','2','3','4','5','6','7','8','9','10','J','Q','K']
NO_CARD = {CLUB => [ ], HEART => [ ], SPADE => [ ], DIAMOND => [ ]}
NUMBER_OF_DECKS = 2

def say(s)
  puts "--- #{s} ---"
end

def new_deck
  # deck = {CLUB => RANKS.dup, HEART => RANKS.dup, SPADE => RANKS.dup, DIAMOND => RANKS.dup}
  deck = NO_CARD.dup
  x = 0
  while x < NUMBER_OF_DECKS
    [CLUB, HEART, SPADE, DIAMOND].each do |suit|
      deck[suit].concat(RANKS)
    end
    x +=1
  end
  deck
end

def new_game

  deck = new_deck
  player_hand = NO_CARD.dup
  dealer_hand = NO_CARD.dup

  for i in 1..2 do
    hit(player_hand, deck)
  end
  for i in 1..2 do
    hit(dealer_hand, deck)
  end

  player_turn(player_hand, deck)
  dealer_turn(dealer_hand, deck)

  check_winner(player_hand, dealer_hand)
  play_again?

end

def hit(hand,deck)
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
  s = 0
  [CLUB, HEART, SPADE, DIAMOND].each do |suit|
    s += sub_sum(hand, suit)
  end
  return s
end

def sub_sum(hand, suit)
  sub_s = 0
  hand[suit].each do |rank|
    if rank == 'A'
      sub_s += 1
    elsif ['J','Q','K'].include?(rank)
      sub_s += 10
    else
      sub_s += rank.to_i
    end
  end
  return sub_s
end

def player_turn(hand,deck)
  say "Your hand: #{hand}"
  say "Your hand sums up to #{sum(hand)}"
  if sum(hand) > 21
    say "You're busted!"
    play_again?
  else
    say "Hit or Stay?"
    choice = gets.chomp.downcase
    if choice == "hit"
      hit(hand,deck)
      player_turn(hand,deck)
    elsif choice == "stay"
      return
    else
      say "Invalid choice. Try again."
      player_turn(hand,deck)
    end
  end
end

def dealer_turn(hand,deck)
  say "Dealer's hand: #{hand}"
  say "Dealer's hand sums up to #{sum(hand)}"
  if sum(hand) < 17
    hit(hand,deck)
    dealer_turn(hand,deck)
  elsif sum(hand) > 21
    say "Dealer is busted. You won!"
    play_again?
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

def play_again?
  say "Play again? (Y/N)"
  choice = gets.chomp.downcase
  if choice == 'y'
    new_game
  elsif choice == 'n'
    say "See you next time!"
    abort
  else
    say "Invalid choice. Try again."
    play_again?
  end
end

new_game
