# Godot 4 Board Game Framework

A project to create a framework for board games with graphical interface but also playable at the terminal in automatic rounds to gather data etc.

https://github.com/BrnLng/2606-jam

---

## CLI App -- ECS Simulation

In a nutshell, it is a procedural game engine. Everything built under a testable logic, easy to change and test. This project is to be the base of a comprehensive board game framework that will allow us to create board games easily and with a solid architecture.

Its logic is to be later fully integrated to Godot engine, with all visuals and UI made in it, but all core code should be translatable to any engine/environment.

### Rules for the CLI frontend:

1. **No Visual Components/Headless**: Everything happens in the terminal.
2. **State-Based**: The game logic lives in `GameState.gd`, not in the Scene Tree.
3. **Zonal ECS**: We use **Zones** (the game board, a tableau grid, a hand, a deck etc.) to manage **Entities**, like the game pieces (Components based).
4. **Entity Composition**: Mostly everything is an Entity, like Players themselves and the game board, which is also a Zone. Game pieces are created by attaching Components to an Entity ID.
5. **Data and Rule-Driven**: The game state is stored in a way that can be easily serialized and deserialized. Logic and agents are implemented in a rule engine, not in the Scene Tree. It foresees ways to change game rules on the fly -- events can trigger changes in both game context or rules, turn order or even the game mode.

## Project Structure
```
- Project Root
  - core/               # ECS Logic
    - definitions/      # Game Data
    - state/            # ECS State Manager
      - components/     # Data containers
    - system/           # Game Rules / Systems
    - entity.gd
    - game_state.gd     # The main manager
    - zone.gd           # Area/board logic
  - unit_test/          # All tests should be here
  - main.gd             # The entry point
```

## Command line execution

- `godot --headless -s main.gd`

## Unit tests

- `godot --headless --path . -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd -a "res://unit_test/" --ignoreHeadlessMode`

