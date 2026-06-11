# Godot 4 Board Game Framework

## CLI App -- ECS Simulation

In a nutshell, it is a procedural game engine. Everything under a testable logic, easy to change and test. This is, the core of the framework. This project is to be the base of a comprehensive board game framework that will allow us to create board games easily and with a solid architecture. The framework will be used to create board games both with a graphical interface but also playable as board games for the terminal in automatic rounds to gather data etc.

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

