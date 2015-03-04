require "sinatra"
require "pry"

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

def comp_choice
  choice = ["rock", "paper", "scissors"]
  choice[rand(0..2)]
end

get '/' do
  session[:comp_choice] = comp_choice
  session[:player_score] = 0
  session[:computer_score] = 0
  session[:last_round] = ""

  erb :home
end

post '/choose' do
  
  winning_combos = [["rock", "scissors"], ["scissors", "paper"], ["paper", "rock"]]
  player_choice = params["choice"]

  if winning_combos.include?([player_choice, session[:comp_choice]])
    session[:last_round] = "#{player_choice} beats #{session[:comp_choice]},
    player wins the round!"
    session[:player_score] += 1

  elsif player_choice == session[:comp_choice]
    session[:last_round] = "Tie, choose again"

  else
    session[:last_round] = "#{session[:comp_choice]} beats #{player_choice},
    computer wins the round.."
    session[:computer_score] += 1
  end

  redirect '/choose'
end

get '/choose' do
  session[:comp_choice] = comp_choice
  session[:computer_score]
  session[:player_score]
  session[:last_round]

  erb :home
end
