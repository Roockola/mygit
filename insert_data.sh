#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
while IFS=',' read -r year round winner opponent winner_goals opponent_goals; do
  #echo "$year | $round | $winner | $opponent | $winner_goals | $opponent_goals"
  if [[ $winner == 'winner' || $opponent == 'opponent' ]]
    then 
      continue
    else
      #echo "$winner"
      WIN_RES=$($PSQL "INSERT INTO teams (name) VALUES ('$winner')")
      OPP_RES=$($PSQL "INSERT INTO teams (name) VALUES ('$opponent')")
      echo "$WIN_RES | $OPP_RES"
  fi
done < "games.csv"

while IFS=',' read -r year round winner opponent winner_goals opponent_goals; do
  #echo "$year | $round | $winner | $opponent | $winner_goals | $opponent_goals"
  if [[ $winner == 'winner' || $opponent == 'opponent' ]]
    then 
      continue
    else
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
      OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
      GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $WINNER_ID, $OPP_ID, $winner_goals, $opponent_goals)")
      echo "$GAME"
  fi
done < "games.csv"

