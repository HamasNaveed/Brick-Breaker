# Brick-Breaker
Brick Breaker Game
Overview
This is a classic Brick Breaker game implemented in x86 Assembly language using the Irvine32 library. The game features multiple levels, a scoring system, player lives, a countdown timer, and a leaderboard to store high scores. The objective is to break all bricks on the screen using a paddle to bounce a ball, while avoiding letting the ball fall below the paddle.
Features

Gameplay Mechanics:
Control a paddle using 'A'/'D' or left/right arrow keys to move left and right.
The ball bounces off walls, the paddle, and bricks.
Break all bricks to progress to the next level.
Avoid letting the ball fall below the paddle to prevent losing a life.


Levels:
Level 1: Standard paddle size, basic brick layout, and moderate ball speed.
Level 2: Reduced paddle size, increased ball speed, and same brick layout.
Level 3: Further reduced paddle size, faster ball speed, a randomly placed "solid" brick with high health, and a special brick that destroys up to 5 adjacent bricks when hit.


Special Features:
Special Brick: In Level 3, a designated brick (white-colored) triggers the destruction of up to 5 adjacent bricks and adds 30 seconds to the timer when destroyed.
Timer: A countdown timer starts at 300 seconds. The game ends if the timer reaches zero or all lives are lost.
Lives: Players start with 3 lives, displayed as heart symbols. Losing a life resets the ball to the paddle's center.
Scoring: Points are awarded for each brick destroyed. Scores are saved to a leaderboard.
Leaderboard: Stores top 10 player names, scores, and levels in output.txt. Accessible from the main menu.
Sound Effects: Includes sounds for game start, level completion, life loss, and game over using .wav files.


Menu System:
Main menu with options to start the game, view instructions, or view the leaderboard.
Navigation using keys '1', '2', '3', and Enter to select options.
ASCII art for visual appeal in menus and game over screens.


Pause Functionality: Press 'P' to pause/resume the game.

Requirements

Operating System: Windows (due to the use of Irvine32 library and Winmm.lib for sound).
Assembler: MASM (Microsoft Macro Assembler).
Libraries:
Irvine32.inc and Irvine32.lib for console I/O and utility functions.
macros.inc for additional macro utilities.
Winmm.lib for playing sound effects.


Sound Files:
GameStart.wav
LevelComplete.wav
LifeEnd.wav
GameOver.wavEnsure these files are in the same directory as the executable.


Output File: output.txt for storing leaderboard data (created automatically if not present).

Installation

Set up MASM:
Install Visual Studio with MASM support or use a standalone MASM setup.
Ensure the Irvine32 library is installed and configured in your project directory.


Copy Sound Files:
Place the required .wav files (GameStart.wav, LevelComplete.wav, LifeEnd.wav, GameOver.wav) in the project directory.


Assemble and Link:
Assemble the source code using MASM:ml /c /Zd /coff BrickBreaker.asm


Link the object file with Irvine32.lib and Winmm.lib:link BrickBreaker.obj Irvine32.lib Winmm.lib /SUBSYSTEM:CONSOLE




Run the Game:
Execute the generated BrickBreaker.exe in a Windows command prompt.



How to Play

Start the Game:
Launch the executable.
Enter your name when prompted (up to 20 characters).
Navigate the main menu using '1', '2', '3' to select Start, Instructions, or Leaderboard, and press Enter to confirm.


Controls:
A/D or Left/Right Arrow Keys: Move the paddle left or right.
P: Pause/resume the game.
Spacebar: Not used in this version (ball launches automatically).
Esc: Return to the main menu from Instructions or Leaderboard screens.


Gameplay:
Move the paddle to bounce the ball and hit bricks.
Each brick destroyed increases your score.
Progress through 3 levels with increasing difficulty.
Avoid losing lives by keeping the ball above the paddle.
Monitor the timer and lives displayed on the right side of the screen.


Game Over:
Occurs when all lives are lost or the timer reaches zero.
Displays a game over message with ASCII art and saves your score to the leaderboard.
Press any key to exit.



File Structure

BrickBreaker.asm: The main source code file containing the game logic.
Irvine32.inc, Irvine32.lib, macros.inc: Required Irvine32 library files.
Winmm.lib: Windows multimedia library for sound playback.
GameStart.wav, LevelComplete.wav, LifeEnd.wav, GameOver.wav: Sound effect files.
output.txt: Generated file for storing leaderboard data (name, score, level).

Leaderboard

Stored in output.txt in the format: name,score.
Displays top 10 scores with player names, scores, and levels.
Automatically updates when a game ends, replacing the lowest score if the new score is higher or updating an existing player's score if higher.

Notes

The game runs in a console window with a fixed size (typically 80x25 characters).
Ensure the console font supports ASCII art (e.g., Consolas or Lucida Console).
The special brick in Level 3 is randomly selected and highlighted in white when healthStage is 4.
The solid brick in Level 3 has a health of 30, making it significantly harder to destroy.
The game uses a delay (delayValue) to control ball speed, decreasing from 150ms (Level 1) to 90ms (Level 3).

Known Issues

Sound Playback: Requires .wav files to be present; otherwise, the game may crash or skip sound effects.
Console Size: The game assumes a standard 80x25 console. Non-standard sizes may cause display issues.
Leaderboard Parsing: Large or malformed output.txt files may cause parsing errors.
Randomization: The special brick and solid brick in Level 3 use a simple random number generator, which may not be perfectly uniform.

Future Improvements

Add power-ups (e.g., paddle expansion, extra lives) as mentioned in instructions.
Implement a level selection menu.
Support additional levels with varied brick layouts.
Enhance randomization for special and solid bricks.
Add error handling for missing sound files.
Allow saving and loading game state.

Credits

Developed using x86 Assembly and the Irvine32 library.
ASCII art created for menus and game over screens.
Inspired by classic Brick Breaker games like Breakout.

License
This project is for educational purposes and uses the Irvine32 library, which has its own licensing terms. Ensure compliance with Irvine32's license when distributing or modifying the code.
