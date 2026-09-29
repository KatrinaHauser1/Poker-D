import std.stdio;
import std.file;
import std.string;
import std.conv;
import core.stdc.stdlib;
import cards : cards;
import std.algorithm;

void printIntro(string[] args) {

    writeln("✦✦✦✦✦ POKER ✦✦✦✦✦ HAND ✦✦✦✦✦ ANALYZer ✦✦✦✦✦");

    if (args.length == 1) {
        writeln("\n✦✦✦✦✦ USING ✦✦✦✦ RANDOMIZED ✦✦✦✦ DECK ✦✦✦✦✦");
    }

    else {
        writeln("✦✦✦✦✦✦ File - " ~ args[1] ~ " ✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦");
        writeln("\n✦✦✦✦✦ USING ✦✦✦✦✦ TEST ✦✦✦✦✦✦✦ DECK ✦✦✦✦✦");
    }
}

cards[] testDeck(string[] args) {

    cards[] testHand = new cards[7];
    string testFile = args[1];

    if (exists(testFile)) {
        auto file = File(args[1], "r");
        string[] tokens;

        foreach (line; file.byLine()) {
            tokens ~= line.idup.split(",");
        }

        if (tokens.length != 7) {
            writeln("Error: File contains too many/not enough cards\n");
            exit(1);
        }

        for (size_t i = 0; i < tokens.length; i++) {
            if (tokens[i].length != 3) {
                writeln("\nError: Incorrect Card Format");
                exit(1);
            }
            int value = 0;
            string suitCheck = tokens[i][0 .. 2];
            if (suitCheck == " J") {
                value = 11;
            }
            else if (suitCheck == " Q") {
                value = 12;
            }
            else if (suitCheck == " K") {
                value = 13;
            }
            else if (suitCheck == " A") {
                value = 14;
            }
            else if (suitCheck == "10") {
                value = 10;
            }
            else {
                value = (tokens[i][1 .. 2]).to!int;
            }
            testHand[i] = new cards(tokens[i], value, tokens[i][2 .. 3]);
        }

        writeln("\n✦✦✦✦✦✦✦✦✦✦✦✦✦✦ Your Hand: ✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦");
        for (int h = 0; h < 7; h++) {
            write(testHand[h].card ~ " ");
        }
        writeln("\n✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦✦");

        cards[] tempHand;
        for (int i = 0; i < 7; i++) {
            tempHand ~= testHand[i];
        }

        tempHand.sort!((a, b) => a.value < b.value);

        for (int k = 0; k < tempHand.length - 1; k++) {
            if (tempHand[k].card == tempHand[k + 1].card) {
                writeln("\nError: Duplicate found in Hand");
                writeln("DUPLICATE: " ~ tempHand[k].card);
                exit(1);
            }
        }
    }
    else {
        writeln("\nError: File not found");
        exit(1);
    }
   
    return testHand;
}

void main(string[] args) {

    cards myCards = new cards("", 0, "");
    printIntro(args);

    cards[] activeHand;

    if (args.length == 1) {
        myCards.deliverStackandHand();
        activeHand = myCards.getMyHand();
    }

    else {
        activeHand = testDeck(args);
    }
 
   myCards.evaluateHand(activeHand);
}
