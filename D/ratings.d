import std.algorithm;
import std.array;
import cards : cards;

class ratings {

	cards[] playedHand;
	cards[] extraCards;
	int score;
	int[] tiebreak;

	this(cards[] combination) {

		playedHand = new cards[5];
		extraCards = new cards[2];

		for (int i = 0; i < 7; i++) {
			if (i < 5) {
				playedHand[i] = combination[i];
			}

			else {
				extraCards[i-5] = combination[i];
			}
		}

		playedHand.sort(); 

		score = getScore(playedHand);
		tiebreak = getTiebreak(playedHand, score);
	}

	int getScore(cards[] playable) {

		int score = 0;


		if (isAscending(playable) && isFlush(playable) && (playable[0].value == 10)){
			score = 10;
		}

		else if (isAscending(playable) && isFlush(playable)) {
			score = 9;
		}

		else if (numDuplicates("four of a kind", playable)) {
			score = 8;
		}
		else if (numDuplicates("full house", playable)) {
			score = 7;
		}

		else if (isFlush(playable)) {
			score = 6;
		}

		else if (isAscending(playable)) {
			score = 5;
		}

		else if (numDuplicates("three of a kind", playable)) {
			score = 4;
		}   
		else if (numDuplicates("two pair", playable)) {
			score = 3;
		}

		else if (numDuplicates("pair", playable)) {
			score = 2;
		}

		else {
			score = 1;
		}
		return score;
	}



	// tiebreka array (priority is from 0 to arraylength)
	// only cards of the same score are tiebroken so arraylenght is always the same
	int[] getTiebreak(cards[] playable, int score) {

		int[] tiebreak = new int[5];
		int index = 0;

		switch (score) {
			case 10:
				tiebreak[0] = cardStrength(playable[4]);
				break;
			case 9:
			case 5:
				if (playable[4].value == 14 && playable[0].value == 2) {
					tiebreak[0] = cardStrength(playable[3]);
				}
				else {
					tiebreak[0] = cardStrength(playable[4]);
				}
				break;

			case 8:
				int fourValue = playable[2].value;

				for (int i = 4; i >= 0; i--) {
					if (playable[i].value == fourValue) {
						tiebreak[index] = cardStrength(playable[i]);
						index++;
					}
				}


				for (int i = 4; i >= 0; i--) {
					if (playable[i].value != fourValue) {
						tiebreak[index] = cardStrength(playable[i]);
						break;
					}
				}

				break;


			case 7:
				int threeValue = playable[2].value;

				for (int i = 4; i >= 0; i--) {
					if (playable[i].value == threeValue) {
						tiebreak[index] = cardStrength(playable[i]);
	                                        index++;
					}
				}

				if (tiebreak[0] < tiebreak[1]) { 
					int t = tiebreak[0]; tiebreak[0] = tiebreak[1]; tiebreak[1] = t; 
				}
				if (tiebreak[1] < tiebreak[2]) { 
					int t = tiebreak[1]; tiebreak[1] = tiebreak[2]; tiebreak[2] = t; 
				}
				if (tiebreak[0] < tiebreak[1]) { 
					int t = tiebreak[0]; tiebreak[0] = tiebreak[1]; tiebreak[1] = t; 
				}


				for (int i = 4; i >= 0; i--) {
					if (playable[i].value != threeValue) {
						tiebreak[index] = cardStrength(playable[i]);
						index++;
					}
				}

				if (tiebreak[3] < tiebreak[4]) { 
					int t = tiebreak[3]; tiebreak[3] = tiebreak[4]; tiebreak[4] = t; 
				}
				break;


			case 6:
				for (int i = 4; i >= 0; i--) {
					tiebreak[index] = cardStrength(playable[i]);
					index++;
				}
				break;


			case 4:
				int tripValue = playable[2].value;

				for (int i = 4; i >= 0; i--) {
					if (playable[i].value == tripValue) {
						tiebreak[index] = cardStrength(playable[i]);
						index++;
					}
				}

				if (tiebreak[0] < tiebreak[1]) { 
					int t = tiebreak[0]; tiebreak[0] = tiebreak[1]; tiebreak[1] = t; 
				}
				if (tiebreak[1] < tiebreak[2]) {
					int t = tiebreak[1]; tiebreak[1] = tiebreak[2]; tiebreak[2] = t; 	
				}
				if (tiebreak[0] < tiebreak[1]) { 
					int t = tiebreak[0]; tiebreak[0] = tiebreak[1]; tiebreak[1] = t; 
				}



				for (int i = 4; i >= 0; i--) {
					if (playable[i].value != tripValue) {
						tiebreak[index] = cardStrength(playable[i]);
						index++;
					}
				}

				if (tiebreak[3] < tiebreak[4]) { 
					int t = tiebreak[3]; tiebreak[3] = tiebreak[4]; tiebreak[4] = t; 
				}
				break;


			case 3:
				int highPair = playable[3].value;
				int lowPair = playable[1].value;

				for (int i = 4; i >= 0; i--) {
					if (playable[i].value == highPair) {
						tiebreak[index] = cardStrength(playable[i]);
						index++;
					}
				}

				if (tiebreak[0] < tiebreak[1]) { 
					int t = tiebreak[0]; tiebreak[0] = tiebreak[1]; tiebreak[1] = t;
				}

				for (int i = 4; i >= 0; i--) {
					if (playable[i].value == lowPair) {
						tiebreak[index] = cardStrength(playable[i]);
						index++;
					}
				}

				if (tiebreak[2] < tiebreak[3]) {
					int t = tiebreak[2]; tiebreak[2] = tiebreak[3]; tiebreak[3] = t; 
				}

				for (int i = 4; i >= 0; i--) {
					if (playable[i].value != highPair &&
							playable[i].value != lowPair) {
						tiebreak[index] = cardStrength(playable[i]);
						index++;
						break;
					}
				}
				break;

			case 2:
				int pairValue = 0;

				for (int i = 0; i < 4; i++) {
					if (playable[i].value == playable[i + 1].value) {
						pairValue = playable[i].value;
						break;
					}
				}

				for (int i = 4; i >= 0; i--) {
					if (playable[i].value == pairValue) {
						tiebreak[index] = cardStrength(playable[i]);
						index++;
					}
				}

				if (tiebreak[0] < tiebreak[1]) { 
					int t = tiebreak[0]; tiebreak[0] = tiebreak[1]; tiebreak[1] = t; 
				}

				for (int i = 4; i >= 0; i--) {
					if (playable[i].value != pairValue) {
						tiebreak[index] = cardStrength(playable[i]);
						index++;
					}
				}
				break;
			case 1:
			default:
				for (int i = 4; i >= 0; i--) {
					tiebreak[index] = cardStrength(playable[i]);
					index++;
				}
				break;
		}

		return tiebreak;
	}


	int cardStrength(cards card) {
		return card.value * 10 + getSuitLevel(card.suit);
	}				

	int getSuitLevel(string suit) {

		switch (suit) {
			case "D":
				return 1;
			case "C":
				return 2;
			case "H":
				return 3;
			case "S":
				return 4;
			default:
				return 0;
		}
	}


	bool isAscending(cards[] playable) {

		bool normalStraight = true;

		for (int i = 0; i < playable.length-1; i++){
			if ((playable[i].getValue()+1) != (playable[i+1].getValue())) {
				normalStraight = false;
			}

		}
		if (normalStraight) { 
			return true;
		}

		if (playable[4].getValue() == 14 && playable[0].getValue() == 2 && playable[1].getValue() == 3 && playable[2].getValue() == 4 && playable[3].getValue() == 5) {
			return true;
		}

		return false;
	}

	int sumUp(cards[] playable){

		int sum = 0;
		for (int i = 0; i < playable.length; i++){
			sum += playable[i].getValue();
		}

		return sum;
	}

	bool isFlush(cards[] playable) {
		for (int i = 0; i < playable.length-1; i++){
			if (!((playable[i].getSuit()) == (playable[i+1].getSuit()))) {
				return false;
			}

		}
		return true;
	}

	// detect presence of specified type of duplicates
	bool numDuplicates(string handtype, cards[] playable) {

		int[] duplicates = new int[15];
		for (int i = 0; i < playable.length; i++){
			int currentValue = playable[i].getValue();
			duplicates[currentValue]++;
		}

		duplicates.sort();

		int highest = duplicates[duplicates.length - 1];
		int secondHighest = duplicates[duplicates.length - 2];

		switch(handtype) {
			case "pair":
				return highest == 2 && secondHighest == 1;
			case "two pair":
				return highest ==2 && secondHighest == 2;
			case "three of a kind":
				return highest == 3 && secondHighest == 1;
			case "four of a kind":
				return highest >= 4;
			case "full house":
				return highest == 3 && secondHighest == 2;
			default:
				return false;

		}

	}

	string convertScoreToHand(int score) {
		switch(score) {
			case 1:
				return "High Card";
			case 2:
				return "Pair";
			case 3:
				return "Two Pair";
			case 4:
				return "Three of a Kind";
			case 5:
				return "Straight";
			case 6:
				return "Flush";
			case 7:
				return "Full House";
			case 8:
				return "Four of a Kind";
			case 9:
				return "Straight Flush";
			case 10:
				return "Royal Straight Flush";
			default:
				return "Could not determine score";
		}
	}


	// same comparison logic
	int opCmp(ratings other) const {
		if (this.score != other.score) {
			return other.score - this.score;
		}
		for (int i = 0; i < this.tiebreak.length; i++) {
			if (this.tiebreak[i] != other.tiebreak[i]) {
				return other.tiebreak[i] - this.tiebreak[i];
			}
		}
		return 0;
	}	
}
