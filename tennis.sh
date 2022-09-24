#!/bin/bash

player1_score=50
player1_last_move=0

player2_score=50
player2_last_move=0

ball_location=0
game_on=true



#print the score of the two players
print_score() {
    echo " Player 1: ${player1_score}         Player 2: ${player2_score} "
}


#print the board with the ball at its current position
print_board () {
  echo " --------------------------------- "
  echo " |       |       #       |       | "
  echo " |       |       #       |       | "

  case "$ball_location" in
   "-3") echo "O|       |       #       |       | " ;;
   "-2") echo " |   O   |       #       |       | " ;;
   "-1") echo " |       |   O   #       |       | " ;;
   "0")  echo " |       |       O       |       | " ;;
   "1")  echo " |       |       #   O   |       | " ;;
   "2")  echo " |       |       #       |   O   | " ;;
   "3")  echo " |       |       #       |       |O" ;;
  esac

  echo " |       |       #       |       | "
  echo " |       |       #       |       | "
  echo " --------------------------------- "
}


#print the last move of the two players
print_last_move(){
    echo -e "       Player 1 played: ${player1_last_move}\n       Player 2 played: ${player2_last_move}\n\n"
}


#update the score of the two players
update_score() {
    player1_score=$((player1_score - player1_last_move))
    player2_score=$((player2_score - player2_last_move))
}
 
 
#get input from the two players and validate it
get_input(){
    invalid_choice=true

    while $invalid_choice
    do
        echo "PLAYER 1 PICK A NUMBER: "
        read -s choice
        #while choice is a number and 0 < choice < player1_score
        if [[ $choice =~ [[:digit:]] ]] && [[ $choice -ge 0 ]] && [[ $choice -le $player1_score ]]
            then
            invalid_choice=false
        else
            echo "NOT A VALID MOVE !"
        fi
    done
    player1_last_move=$choice

    invalid_choice=true

    while $invalid_choice
    do
        echo "PLAYER 2 PICK A NUMBER: "
        read -s choice
        #while choice is a number and 0<choice<player2_score
        if [[ $choice =~ [[:digit:]] ]] && [[ $choice -ge 0 ]] && [[ $choice -le $player2_score ]]
            then
            invalid_choice=false
        else
            echo "NOT A VALID MOVE !"
        fi
    done
    player2_last_move=$choice
}


#place the ball in a new location, according to the last move
place_ball(){
    if [[ $player1_last_move -gt $player2_last_move ]]
        then
        case "$ball_location" in
        "-2") ball_location=1;;
        "-1") ball_location=1;;
        "0")  ball_location=1;;
        "1")  ball_location=2;;
        "2")  ball_location=3;;
        esac

    elif [[ $player1_last_move -lt $player2_last_move ]]
        then
        case "$ball_location" in
        "-2") ball_location=-3;;
        "-1") ball_location=-2;;
        "0")  ball_location=-1;;
        "1")  ball_location=-1;;
        "2")  ball_location=-1;;
        esac

    fi
}


#check if one of the players won in this round
check_winner(){

    winner=0

    if [[ $ball_location == "-3" ]]
        then
        winner=2
    
    elif [[ $ball_location == "3" ]]
        then
        winner=1

    elif [[ $player1_score == 0 ]] && [[ $player2_score != 0 ]]
        then
        winner=2

    elif [[ $player2_score == 0 ]] && [[ $player1_score != 0 ]]
        then
        winner=1

    elif [[ $player1_score == 0 ]] && [[ $player2_score == 0 ]]
        then 
        if [[ $ball_location -gt 0 ]]
            then
            winner=1

        elif [[ $ball_location -lt 0 ]]
            then
            winner=2

        else
            echo "IT'S A DRAW !"
            game_on=false
        fi
    fi

    if [[ $winner != "0" ]]
        then
        echo "PLAYER $winner WINS !"
        game_on=false
    fi
}


#game flow
play(){
    get_input
    update_score
    place_ball
    print_score
    print_board
    print_last_move
    check_winner
}


# main:
print_score
print_board
while $game_on
do
  play
done
