# Current Focus
## Make sure to define the very next small step before closing the project.
*What is the single most important thing to do right now?
- [ ] Create events history (list of all moves) to enable future simulations and replay/undo features.

---

# In Progress (WIP 1-2 items only)
*What is currently being worked on? (Try to keep this to 1-2 items max to avoid overwhelm)*

---

# Backlog (To Do)
*What needs to get done eventually? Keep it broken down into small, actionable steps.*

### High Priority
- [ ] Make basic class: Action/Intent, to be used by agents to express intentions (i.e. "place piece at position")
- [ ] Make basic class: GameplayManager, to manage game flow rules, i.e. turn/phase order, game end, etc
- [ ] Make basic class: GameRulesEngine, which applies rules, validate moves, game end, etc
- [ ] Make basic class: Event, to be used to record game events, state changes, etc
- [ ] Make basic class: RuleDefinition, which encapsulates rules of each game. Allows easy configuration and changes.
- [ ] Make basic class: Entity, which is a container for components.
- [ ] Make basic class: Component, which is a data container.
- [ ] Make basic class: Zone, which is a container for entities and components.
- [ ] Make basic class: Agent, which is a player in the game.
- [ ] Make basic class: GameState, which is the state/context of the game.
- [ ] Make basic class: GameDefinition, which is the definition of the game.
- [ ] Make basic class: Effect, which is a change in the game state.
- [ ] Make a basic rule-engine, like TicTacToe, to demonstrate the framework

### Medium/Low Priority
- [ ] Make agents with different strategies (greedy, etc)

---

# History (Completed / Redone)
*What got done and when? Add new entries to the TOP of this list.*

## 2026-06-22
- [x] Make agents with different strategies (random)
- [x] make current main.gd an script that can create/initialize a game from a definition and run simulation in batch mode from command line args, using only logic files inside core
- [x] we need a way to automatically pick moves for the board game to be playable in batch mode -- Add `get_valid_moves(state, definition)` to GameRules: Currently, GameRules can only `validate_move(coord)`. If we want to simulate games automatically, we need to be able to ask the rules engine: "What are all the legal moves right now?" so an automated script or agent can pick one.
- [x] Implement CLI Parsing in main.gd: Use OS.get_cmdline_user_args() in _init() to check for a flag like --batch or --simulate=100.
- [x] Created `tasklog.md` file to keep track of project progress, backlog, and history.

---

# 🧠 Braindump / Notes
*Unstructured thoughts, bugs found, or things to remember later without having to organize them right now.*
- 
Later it will be possible to create any board game visually too.