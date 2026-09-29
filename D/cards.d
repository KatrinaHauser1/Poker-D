module cards;

import std.stdio;
import std.algorithm;
import std.array;
import std.random;
import std.range;
import std.conv;
import std.string;
import ratings : ratings;

class cards {

	enum int CARDS_IN_DECK = 52;
	enum int CARDS_DRAWN = 7;
	enum int NUM_COMBINATIONS = 21;

	string card;
	int value;
	string suit;
	cards[] myHand;

	this(string card, int value, string suit) {

		this.card = card;
		this.value = value;
		this.suit = suit;
	}

	// D snytax for comparison (instead of compareTo)
	int opCmp(cards other) const {

		if (this.value != other.value) {
			return (this.value < other.value) ? -1 : ((this.value > other.value) ? 1 : 0);
		}

		int thisSuitLevel = getSuitLevel(this.suit);
		int otherSuitLevel = getSuitLevel(other.suit);
		return (thisSuitLevel < otherSuitLevel) ? -1 : ((thisSuitLevel > otherSuitLevel) ? 1 : 0);
	}

	int getValue() {
		return this.value;
	}

	string getSuit() {
		return this.suit;
	}

	cards[] getMyHand() {
		return this.myHand;
	}

	int getSuitLevel(string suit) const {
		switch (suit) {
			case "D": return 1;
			case "C": return 2;
			case "H": return 3;
			case "S": return 4;
			default: return 0;
		}
	}

	cards[] initializeStack() {
		string[] cardStrings = [
			" 2H", " 3H", " 4H", " 5H", " 6H", " 7H", " 8H", " 9H", "10H", " JH", " QH", " KH", " AH", 
			" 2D", " 3D", " 4D", " 5D", " 6D", " 7D", " 8D", " 9D", "10D", " JD", " QD", " KD", " AD", 
			" 2C", " 3C", " 4C", " 5C", " 6C", " 7C", " 8C", " 9C", "10C", " JC", " QC", " KC", " AC", 
			" 2S", " 3S", " 4S", " 5S", " 6S", " 7S", " 8S", " 9S", "10S", " JS", " QS", " KS", " AS"
		];

		cards[] myStack = new cards[CARDS_IN_DECK];
		for (int i = 0; i < cardStrings.length; i++) {
			int value = 0;
			string prefix = cardStrings[i][0 .. 2];
			switch (prefix) {
				case " J":
					value = 11;
					break;
				case " Q":
					value = 12;
					break;
				case " K":
					value = 13;
					break;
				case " A":
					value = 14;
					break;
				case "10":
					value = 10;
					break;
				default:
					value = cardStrings[i][1 .. 2].to!int;
					break;
			}
			myStack[i] = new cards(cardStrings[i], value, cardStrings[i][2 .. $]);
		}

		return myStack;
	}

	cards[] shuffleStack(cards[] myStack) {
		cards[] myShuffledStack = new cards[CARDS_IN_DECK];
		for (int i = 0; i < CARDS_IN_DECK; i++) {
			while (true) {
				int newPos = uniform(0, CARDS_IN_DECK);
				if (myShuffledStack[newPos] is null) {
					myShuffledStack[newPos] = myStack[i];
					break;
				}
			}
		}
		return myShuffledStack;
	}

	cards[] drawHand(cards[] myStack) {
		cards[] myHand = new cards[CARDS_DRAWN];
		for (int i = 0; i < CARDS_DRAWN; i++) {
			myHand[i] = myStack[i];
		}
		return myHand;
	}

	void printStack(cards[] myStack) {
		writeln("        ✦✦✦ Shuffled ", CARDS_IN_DECK, " card deck: ✦✦✦");
		for (int i = 0; i < myStack.length; i++) {
			write(myStack[i].card, " ");
			if ((i + 1) % 9 == 0) {
				writeln("");
			}
		}
		writeln("\n✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦");
	}

	void printHand(cards[] myHand) {
		writeln("\n✦✦✦✦✦✦✦✦✦✦✦✦✦✦ Your Hand: ✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦");
		for (int i = 0; i < CARDS_DRAWN; i++) {
			write(myHand[i].card, " ");
		}
		writeln("\n✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦");
	}

	void deliverStackandHand() {
		cards[] myStack = initializeStack();
		myStack = shuffleStack(myStack);
		myHand = drawHand(myStack);
		printStack(myStack);
		printHand(myHand);
	}

	// grade all the hands and sort them
	void evaluateHand(cards[] handArg) {
		cards[] currentHand = handArg;
		if (currentHand is null) {
			currentHand = myHand;
		}

		cards[][] myCombinations = getCombinations(currentHand);
		printCombinations(myCombinations);

		ratings[] handRatings = new ratings[NUM_COMBINATIONS];
		for (int i = 0; i < NUM_COMBINATIONS; i++) {
			handRatings[i] = new ratings(myCombinations[i]);
		}

		handRatings.sort();

		writeln("\n✦✦✦✦✦✦✦✦✦✦✦✦✦HIGH HAND ORDER✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦");
		for (int i = 0; i < NUM_COMBINATIONS; i++) {
			for (int j = 0; j < 5; j++) {
				write(handRatings[i].playedHand[j].card, " ");
			}
			write(" | ", handRatings[i].extraCards[0].card, " ", handRatings[i].extraCards[1].card);
			string Hand = handRatings[i].convertScoreToHand(handRatings[i].score);
			write(" --- ", Hand);
			writeln();
		}
		writeln("\n✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦");
	}

	cards[][] getCombinations(cards[] hand) {
		cards[][] myCombinations = new cards[][](NUM_COMBINATIONS, CARDS_DRAWN);
		int combination = 0;

		for (int i = 0; i < CARDS_DRAWN; i++) {
			for (int j = i + 1; j < CARDS_DRAWN; j++) {
				int index = 0;
				for (int k = 0; k < CARDS_DRAWN; k++) {
					if (k != i && k != j) {
						myCombinations[combination][index] = hand[k];
						index++;
					}
				}
				myCombinations[combination][5] = hand[i];
				myCombinations[combination][6] = hand[j];
				combination++;
			}
		}
		return myCombinations;
	}

	void printCombinations(cards[][] myCombinations) {
		writeln("\n✦✦✦✦✦✦✦✦✦✦ Hand Combinations: ✦✦✦✦✦✦✦✦✦✦✦✦✦");
		for (int i = 0; i < myCombinations.length; i++) {
			for (int j = 0; j < myCombinations[i].length; j++) {
				write(myCombinations[i][j].card, " ");
				if (j == 4) {
					write(" | ");
				}
			}
			writeln("");
		}
	}
}
