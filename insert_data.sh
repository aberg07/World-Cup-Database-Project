#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' && $ROUND != 'round' && $WINNER != 'winner' && $OPPONENT != 'opponent'
  && WINNER_GOALS != 'winner_goals' && OPPONENT_GOALS != 'opponent_goals' ]]
  then
    CURRENT_WINNER="$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")"
    CURRENT_OPPONENT="$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")"
    #Insert team if it's not in the table
    if [[ -z $CURRENT_WINNER ]]
    then
      INSERT_TEAM_RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi
    #Insert team if it's not in the table
    if [[ -z $CURRENT_OPPONENT ]]
    then
      INSERT_TEAM_RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    INSERT_GAME_RESULT="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id,
    winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID,
    $WINNER_GOALS, $OPPONENT_GOALS)")"
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo "Inserted into games, $WINNER vs. $OPPONENT ($WINNER_GOALS - $OPPONENT_GOALS), the $ROUND of $YEAR"
    fi
  fi
done