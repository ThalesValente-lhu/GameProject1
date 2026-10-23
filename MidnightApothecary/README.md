# Midnight Apothecary

*CS4478 Game Programming, Project 1 (Group 2: Memory Game). Built with HaxeFlixel.*

## 1. What the game is about

You run a potion shop that only opens at midnight. Strange customers (a troll, a vampire, a witch, a ghost, a goblin and a frog prince) walk up to the counter and flash their recipe at you for a few seconds. Then the recipe is hidden and you have to brew it from memory, throwing ingredients into the cauldron in exactly the right order before the customer loses patience. It's a sequence-memory game: every customer is a short memory test, and the tests get harder the longer you keep the shop open.

## 2. Game components

**Customers.** Each customer appears at the top left with a portrait, the potion they want and a line of dialogue. Their recipe is shown on numbered cards underneath.

**Recipe cards.** A row of 3 to 7 numbered cards showing the ingredients in order. During the peek they're visible; once brewing starts they turn into "?" cards.

**Timer bar.** Gold while you're memorizing (the peek). Green, then amber, then red while you're brewing (the customer's patience). When patience is low the customer starts shaking and the clock ticks.

**Cauldron.** Ingredients you add fly through the air and splash into the pot, changing the colour of the brew. The numbered slots under the cauldron show what you've added so far.

**Ingredient shelf.** Eight ingredients, numbered 1 to 8: Toadstool, Sage, Dew, Ember, Crystal, Feather, Stardust and Newt eye.

**Vials (lives).** Three vials in the top bar. A wrong or late potion empties one.

**Score and streak.** Shown in the top bar.

*(Add screenshots here: title screen, peek phase, brewing phase, Perfect brew popup, Wrong recipe popup, Options screen.)*

## 3. Setup and victory conditions

**Setup.** Press *Open the shop* on the title screen. You start with 3 lives, score 0 and the first customer already at the counter. No other setup is needed.

**Goal.** This is an endless score-attack game. There is no fixed end; you "win" by setting the highest score you can before the shop closes. Your best score is saved and shown on the title screen.

**The game ends** when you lose your third life ("The shop is closed").

## 4. Sequence of play

Each customer is one round:

1. **Arrive.** A customer walks in and a bell chimes.
2. **Peek.** The recipe is shown for a few seconds (gold bar). Memorize the ingredients and their order. Press Space (gamepad: A) to skip ahead if you're ready.
3. **Brew.** The recipe is hidden. Add ingredients one at a time in the order you remember (green bar = patience).
4. **Serve.** When the cauldron has the right number of ingredients, serve the potion.
5. **Result.** *Perfect brew* (points), *Wrong recipe* or *Out of patience* (a life lost, with the correct recipe shown next to what you made).
6. **Next customer.**

## 5. Rules (in order of play)

1. Recipes must be brewed in the exact order shown. The right ingredients in the wrong order is a wrong recipe.
2. You can only serve once the cauldron holds as many ingredients as the recipe. Undo removes the last ingredient you added.
3. If the patience bar runs out before you serve, the customer leaves and you lose a life.
4. A wrong recipe costs one life and resets your streak.
5. Every 5th happy customer leaves a spare vial as a tip and restores a life (up to 3).
6. Difficulty rises as you go: recipes grow from 3 to 7 ingredients (one more every 3 customers), peeks get shorter, and from the 7th customer on the same ingredient can appear more than once in a recipe (never twice in a row).
7. **Scoring** for a perfect brew = (50 x recipe length + up to 200 speed bonus for the patience you had left) x streak multiplier. The streak multiplier is +10% per consecutive perfect brew, up to x2.0.

## 6. Controls

| Action | Mouse + Keyboard | Keyboard only | Gamepad |
|---|---|---|---|
| Add ingredient | Click it, or 1-8 | 1-8 | D-pad to choose, A to add |
| Undo | Undo button / Backspace | Backspace | B |
| Serve | Serve button / Enter | Enter | Y |
| Skip peek | Space | Space | A |
| Pause | II button / Esc / P | Esc / P | Start |
| Music on/off | Music button / M | M | Back/Select |

Pick the input device in **Options** (or from the pause menu). During play only the chosen device is used; menus accept everything so you can't get locked out.

## 7. Options (display, resolution, input, sound)

Available from the title screen at any time, with the most common ones also in the pause menu:

- **Music** on/off and **music volume**; **sound effects volume**
- **Input device**: Mouse + Keyboard, Keyboard only, or Gamepad
- **Display mode**: Windowed or Fullscreen
- **Resolution** (desktop): 960x540, 1280x720, 1600x900, 1920x1080
- **Monitor** (desktop): moves the game to any connected display

The game renders internally at 1280x720 and scales to fit any window size. All settings are saved between sessions.

## 8. How it meets the project requirements

- **Real-time audio-visual 2D world:** the peek and patience timers run continuously; animated customers, bubbling cauldron, particle splashes.
- **Controller:** keyboard, mouse and gamepad, all selectable.
- **Sound:** looping background music plus sound effects for adding, undoing, splashing, serving, failing, the ticking clock and the bell.
- **Player control of display devices, resolution and input devices** at any time: the Options screen and pause menu (section 7).
- **Physics and collision detection:** thrown ingredients follow a ballistic arc under gravity (velocity solved so they land in the pot), and a splash is triggered by an overlap test against the cauldron's mouth (only while falling). Splash particles fall under gravity too.

## 9. Building and running

Requires Haxe 4.3+, and HaxeFlixel 5.6 or newer (the code uses the `() -> new State()` style of state switching).

```
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib run lime setup
lime test html5        # browser
lime test mac          # or windows / linux for the desktop build (needed for resolution and monitor options)
```

## 10. Project structure

```
Project.xml               build configuration
source/
  Main.hx, BootState.hx   start-up, loads saved settings
  MenuState.hx            title screen and rules
  OptionsState.hx         display, resolution, monitor, input and audio settings
  PlayState.hx            core game: peek -> brew -> serve loop, physics, scoring, difficulty
  ResultSubState.hx       Perfect brew / Wrong recipe / Out of patience popup
  PauseSubState.hx        pause menu
  GameOverState.hx        final score and high score
  Settings.hx, Controls.hx  saved settings and input mapping
  Ingredient.hx, Customer.hx  game data
  UIButton.hx, IngredientButton.hx, SlotCard.hx, MenuNav.hx, Theme.hx  UI pieces
assets/
  images/                 ingredient, customer and UI art
  sounds/, music/         sound effects and background music
  fonts/                  DejaVu fonts
```

## 11. Credits

- Game design and programming: Group 2, CS4478 Fall 2026 (see each member's notepad.txt)
- Art, sound effects and music: original, made for this project
- Fonts: DejaVu Sans and DejaVu Serif (DejaVu Fonts license, free to redistribute)
- Engine: HaxeFlixel, OpenFL, Lime
