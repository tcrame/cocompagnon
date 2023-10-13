import 'dart:math';

int rollDice(int diceType) {
  return Random().nextInt(diceType) + 1;
}

int rollDices(int nbDices, int diceType) {
  int score = rollDice(diceType);
  nbDices--;
  if(nbDices > 0) {
    return score + rollDices(nbDices, diceType);
  }
  return score;
}

int sendDiceMultipleScoreToBeat(int remainingTimesToRoll, int scoreToBeat, int nbOfSuccess) {
  if (remainingTimesToRoll <= 0) {
    return 0;
  }

  int currentRoll = rollDice(20);
  if (currentRoll >= scoreToBeat) {
    nbOfSuccess++;
  }

  remainingTimesToRoll--;
  if (remainingTimesToRoll > 0) {
    return sendDiceMultipleScoreToBeat(remainingTimesToRoll, scoreToBeat, nbOfSuccess);
  } else {
    return nbOfSuccess;
  }
}

int sendDiceMultiple(int remainingTimesToRoll, int valueOfDice, int result) {
  result += rollDice(valueOfDice);
  remainingTimesToRoll--;
  if (remainingTimesToRoll > 0) {
    return sendDiceMultiple(remainingTimesToRoll, valueOfDice, result);
  } else {
    return result;
  }
}
