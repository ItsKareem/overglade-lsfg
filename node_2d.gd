#include <iostream>
#include <iomanip>
#include <string>
#include <ctime>
#include <cstdlib>

using namespace std;

void puzzleRoom(int &health) {

	while (health > 0) {

		cout << "\nCurrent HP: ";
		for (int i = 0; i < health; i++) {
			cout << "♥";
		}
		cout << "\n";

		string Puzzles[4] = {
			"A giant spider blocks your path.",
			"A locked iron door stands in your way.",
			"A deep chasm splits the room in half.",
			"A pale ghost drifts out of the wall, blocking the hallway."
		};

		string Tools[4] = { "Sword", "Key", "Rope", "Spellbook" };

		int random = rand() % 4;

		cout << "❖ " << Puzzles[random] << endl;
		cout << "\nYou open your toolbox:\n";
		cout << "1. Sword" << setw(10)
			 << "2. Key" << setw(10)
			 << "3. Rope" << setw(10)
			 << "4. Spellbook\n\n";

		cout << "Choose a tool to use (enter number 1–4): ";

		int playerChoice;
		cin >> playerChoice;

		if (playerChoice >= 1 && playerChoice <= 4) {

			if (playerChoice == random + 1) {
				cout << "\nYou take out your " << Tools[playerChoice - 1] << "...\n";
				cout << "It glows with energy as you confront the obstacle.\n";
				cout << "The room trembles for a moment...\n";
				cout << "✓ Success! The challenge yields and you move to the next room.\n";
				return; // leave the room
			}
			else {
				cout << "\nYou try using your " << Tools[playerChoice - 1] << "...\n";
				cout << "Nothing happens.\n";
				cout << "✗ You fail the challenge and lose 1♥.\n";
				health--;
				continue; // repeat puzzle with new HP
			}

		}
		else {
			cout << "No such tool exists. Try again.\n";
			continue;
		}
	}

	cout << "\nGame Over! Don't give up, adventurer!\n";
}
int main() {
	int health = 3;
	srand(time(nullptr));

	cout << "Welcome to ESCAPE THE DUNGEON.\n";
	puzzleRoom(health);
	
	return 0;
}
