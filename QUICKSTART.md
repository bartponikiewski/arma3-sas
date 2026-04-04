# SAS Framework — Quickstart Guide

Get a playable mission with intro, briefing, AI tasks, and conversation up and running in under 30 minutes.

---

## Using the repo as a test mission

You don't have to build from scratch. The repo itself is a fully working mission — `mission.sqm` already has all units, markers, named objects, and groups placed in the editor. Every SAS feature is wired up in `init.sqf` and `initPlayerLocal.sqf`.

To run it:
1. Copy the repo folder into `Documents\Arma 3\mpmissions\` (keep the `.Stratis` suffix in the folder name).
2. Host it as a local multiplayer session or open it in Eden Editor.
3. Play — all systems (intro, briefing, tasks, reinforcements, conversations, captives, etc.) are active and ready to test.

Use `init.sqf` and `initPlayerLocal.sqf` from `_examples_` dir as a reference while reading the steps below.

---

## Step 1 — Create a new mission in the editor

1. Open Arma 3 Eden Editor.
2. Pick your map and place your player unit.
3. **File → Save As** — note where the mission folder is saved.
   Default location: `Documents\Arma 3\missions\YourMissionName.MapName\`

---

## Step 2 — Download and copy the SAS framework

1. In your mission dir create `sas` folder
2. Download or clone the SAS repository into this folder.
2. Copy files from `_examples_` into your mission root and edit if needed:

```
YourMissionName.MapName/
├── sas/               ← place all file and folders from this repo here
├── description.ext    ← copy from `_examples_` and edit
```

Your mission folder should now look like:

```
YourMissionName.MapName/
├── sas/
├── description.ext
└── mission.sqm        ← already there from the editor
```

---

## Step 3 — Set up description.ext

Open `description.ext` and update the mission info at the top:

```cpp
author = "YourName";
briefingName = "My Mission";
overviewText = "Short mission description";

class Header
{
    gameType = "Coop";
    minPlayers = 1;
    maxPlayers = 4;
};

respawn = 1;
respawnDelay = 30;
respawnTemplates[] = { "Spectator" };
```

The rest of the file — `cfgFunctions`, `Params`, `RSC`, and comms includes — must stay exactly as copied. These wire up the entire framework:

```cpp
class Params
{
    #include "sas\params\paramIntro.hpp"
    #include "sas\params\paramSkills.hpp"
};

class cfgFunctions
{
    #include "sas\functions.hpp"
};

#include "sas\rsc.hpp"
```

---

## Step 4 — Create init.sqf and initPlayerLocal.sqf

Create two empty files in your mission root:

- `init.sqf` — runs on every machine (server logic, tasks, AI setup)
- `initPlayerLocal.sqf` — runs once per player client (intro, HUD)

You can copy them from the repo and strip out what you don't need, or start from scratch using the examples below.

> **IMPORTANT:** You **must** call `[] call SAS_Init_fnc_finish;` at the very end of `init.sqf`, after all your setup scripts have run. The loading screen stays up until this is called — if you forget it, players will be stuck on the loading screen forever.

---

## Step 5 — Intro + briefing (copy-paste starter)

### initPlayerLocal.sqf

```sqf
// Loading screen runs automatically (postInit) — no call needed.
// Wait for it to finish before starting the intro.
waitUntil { [] call SAS_Init_fnc_getLoadingState };

// Intro sequence — runs on each player's client
[
    ["QUOTE"],
    [
        "OPENING",
        [
            ["Enemy forces have occupied the town.", "Neutralise their command and secure the area."],
            ["Operation Iron Reach"],
            ["LeadTrack01_F_Tacops", true]
        ]
    ],
    ["UAV", player]
] call SAS_Intro_fnc_play;

// Info overlay (player name + location + time)
[] call SAS_Intro_fnc_infoText;
```

**OPENING** array format: `[lines[], titleLines[], [musicClass, fadeIn]]`
- `lines[]` — scrolling text lines shown before the title
- `titleLines[]` — title card lines (first = large, rest = smaller)
- `[musicClass, fadeIn]` — optional music class name + fade bool

To skip the quote screen or UAV shot, simply remove those entries from the array.

### init.sqf

```sqf
// Briefing tasks — shown in the Tasks menu in-game
// Task types: "Attack", "Defend", "Move", "Destroy", "Capture", "Pickup", "Recon"
// Task owner: a named unit, object, or marker name (determines the map marker position)
[
    ["task_neutralise", "Neutralise the commander",  "Find and eliminate the enemy commander.", "Attack",  enemy_leader],
    ["task_secure",     "Secure the town square",    "Hold the position until reinforced.",    "Defend",  mrk_town],
    ["task_extract",    "Reach the extraction point","Move to the LZ and wait for pickup.",    "Move",    mrk_lz]
] spawn SAS_Briefing_fnc_createTasks;

// Briefing sections — shown in the Briefing tab
[
    ["Mission",   "Neutralise the enemy commander and secure the town square."],
    ["Situation", "Enemy forces moved in overnight. Civilian presence is high."],
    ["Execution", "Insert via LZ Alpha, clear the town, extract via LZ Bravo."],
    ["Support",   "One fast-rope capable helo on standby. No CAS available."]
] spawn SAS_Briefing_fnc_createBriefing;

// IMPORTANT: Signal init done — loading screen will fade out
[] call SAS_Init_fnc_finish;
```

---

## Step 6 — AI patrol and guard tasks

### In the editor

1. Place enemy units and group them.
2. Name the **group leader** — e.g. `enemy_patrol_1`, `enemy_guard_1`.
3. Place a marker where you want the patrol/guard to be centred (optional but useful).

### In init.sqf

```sqf
// Patrol — group wanders within 150m of its start position
[group enemy_patrol_1, getPos enemy_patrol_1, 150] call SAS_Task_fnc_patrol;

// Defend — group garrisons buildings and holds position within 80m
// [group, position, radius, garrisonBuildings, doPatrol]
[group enemy_guard_1, getPos enemy_guard_1, 80, true, false] call SAS_Task_fnc_defend;
```

`SAS_Task_fnc_patrol` parameters:

| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | Group | The group to patrol | required |
| 1 | Position | Centre position of the patrol area | required |
| 2 | Number | Max distance between waypoints (metres) | required |

`SAS_Task_fnc_defend` parameters:

| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | Group | The group to defend | required |
| 1 | Position | Position to defend | required |
| 2 | Number | Radius to search for buildings/statics | `100` |
| 3 | Bool | Garrison nearby buildings | `true` |
| 4 | Bool | Also patrol within the defence radius | `false` |

---

## Step 7 — Conversation with an NPC

### In the editor

1. Place a civilian or AI unit.
2. Name it — e.g. `npc_informant`.

### In init.sqf

```sqf
// Add a "Talk" scroll action to the NPC
npc_informant addAction [
    "Talk",
    {
        params ["_target", "_caller"];

        // Simple one-way message (no buttons, auto-closes after 5 seconds)
        ["Informant", _target, "The commander left an hour ago. Headed north.", 5] call SAS_Conv_fnc_message;
    },
    [],
    1.5, true, true, "", "true", 3
];
```

For a branching dialogue with response buttons:

```sqf
npc_informant addAction [
    "Ask for intel",
    {
        params ["_target", "_caller"];

        ["Informant", _target, "What do you want to know?",
            [
                ["Where is the commander?", {
                    ["Informant", _target, "Last seen near the church. Two guards with him.", 6] call SAS_Conv_fnc_message;
                }],
                ["How many enemies?", {
                    ["Informant", _target, "Maybe fifteen. Most are in the warehouse.", 6] call SAS_Conv_fnc_message;
                }],
                ["Never mind", {}]
            ]
        ] call SAS_Conv_fnc_messageDialog;
    },
    [],
    1.5, true, true, "", "true", 3
];
```

`SAS_Conv_fnc_message` — non-blocking overlay, auto-closes:

| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | String | Speaker name | `""` |
| 1 | Object \| String | Unit for live face-cam, or image path | `""` |
| 2 | String | Dialogue text | `""` |
| 3 | Number | Seconds before auto-close | `4` |

`SAS_Conv_fnc_messageDialog` — modal dialog with buttons:

| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | String | Speaker name | `""` |
| 1 | Object \| String | Unit for live face-cam, or image path | `""` |
| 2 | String | Dialogue text | `""` |
| 3 | Array | `[["Button label", { code }], ...]` | `[["Close", {}]]` |

Pass a unit object as the face parameter for a live face-cam. Pass `""` for no portrait.

---

## Step 8 — Reinforcements

The reinforcement system lets AI groups automatically call for help when they take heavy casualties. It is built on top of the morale system — caller groups track fear automatically, so you only need one call per group.

### How it works

1. A **caller group** takes casualties → its fear rises.
2. When fear reaches **0.5** (roughly 50 % casualties) a radio call is simulated (5 s delay + red flare).
3. The nearest available **reinforcement group** moves to support.
4. Each role is one-time: once a caller group has called for help it cannot call again, and once a reinforcement group is dispatched it is removed from the pool.

### In the editor

1. Place two or more enemy groups.
2. Name the **group leaders** — e.g. `enemy_front_1`, `enemy_reserve_1`.

### In init.sqf

```sqf
// Front group — takes contact, calls for reinforcements
[group enemy_front_1, true, false] call SAS_Reinforcement_fnc_registerGroup;

// Reserve group — stays back until called
[group enemy_reserve_1, false, true] call SAS_Reinforcement_fnc_registerGroup;
```

`SAS_Reinforcement_fnc_registerGroup` parameters:

| # | Type | Description |
|---|------|-------------|
| 0 | Object \| Group | Group leader or group |
| 1 | Bool | Can **call** reinforcements (caller) |
| 2 | Bool | Can **be called** as reinforcement (reserve) |

A group can be both caller and reserve — it will call for help when it takes losses and is also available to assist others until dispatched:

```sqf
// Middle group — calls for help AND can be sent as reinforcement
[group enemy_middle_1, true, true] call SAS_Reinforcement_fnc_registerGroup;
```

### Typical three-group layout

```sqf
// Front line — calls for help when taking losses
[group enemy_front_1,  true,  false] call SAS_Reinforcement_fnc_registerGroup;

// Flanking group — calls for help and can reinforce others
[group enemy_flank_1,  true,  true]  call SAS_Reinforcement_fnc_registerGroup;

// Reserve — only available as reinforcement, never calls
[group enemy_reserve_1, false, true]  call SAS_Reinforcement_fnc_registerGroup;
```

> **Note:** Registration must run on the **server** (inside `init.sqf` is correct). The morale tracking for caller groups is set up automatically — you do not need to call `SAS_Morale_fnc_registerGroup` separately.

---

## Step 9 — AI skill params (lobby settings)

SAS provides two lobby parameters that players can adjust before the mission starts.

They are already included in `description.ext` via:

```cpp
#include "sas\params\paramIntro.hpp"
#include "sas\params\paramSkills.hpp"
```

### Intro param

Lets players enable or disable the intro sequence in the lobby. Read the value in `initPlayerLocal.sqf`:

```sqf
// Wait for loading screen to finish
waitUntil { [] call SAS_Init_fnc_getLoadingState };
if ([] call SAS_Intro_fnc_enabled) then {
    [...] call SAS_Intro_fnc_play;
};
```

The function returns `false` when the player disabled intro in the lobby — no extra work needed.

### Skills param

Automatically applies a skill preset to **all units** at mission start. Players choose from the lobby:

| Lobby option | Effect |
|---|---|
| `AUTO` | No change — editor-set skills are kept |
| `NORMAL` | Moderate AI (default) |
| `GOOD` | Competent AI |
| `SPECOPS` | Elite AI |

This is handled automatically by `SAS_Skills_fnc_paramSkills` — you do not need to call anything in your scripts.

To manually override skill on specific units regardless of the param:

```sqf
// Apply preset to a group
[group enemy_guard_1, "GOOD"] call SAS_Skills_fnc_set;

// Apply preset to specific units
[[unit_sniper_1, unit_sniper_2], "SPECOPS"] call SAS_Skills_fnc_set;
```

---

## Minimal init.sqf template

```sqf
// ── Debug (remove for release) ────────────────────────────────────────────
missionNamespace setVariable ["SAS_Debug_global", false];

// ── Briefing ──────────────────────────────────────────────────────────────
[
    ["task_main", "Main objective", "Description here.", "Attack", enemy_leader]
] spawn SAS_Briefing_fnc_createTasks;

[
    ["Mission",   "One sentence summary."],
    ["Situation", "What is happening and why."],
    ["Execution", "What players need to do."],
    ["Support",   "What assets are available."]
] spawn SAS_Briefing_fnc_createBriefing;

// ── AI tasks ──────────────────────────────────────────────────────────────
[group enemy_patrol_1, getPos enemy_patrol_1, 150] call SAS_Task_fnc_patrol;
[group enemy_guard_1,  getPos enemy_guard_1,  80, true, false] call SAS_Task_fnc_defend;

// IMPORTANT: Always call this at the very end — loading screen won't end without it!
[] call SAS_Init_fnc_finish;
```

## Minimal initPlayerLocal.sqf template

```sqf
// Wait for loading screen to finish
waitUntil { [] call SAS_Init_fnc_getLoadingState };
if ([] call SAS_Intro_fnc_enabled) then {
    [
        ["QUOTE"],
        ["OPENING", [
            ["Your mission briefing line here.", "Second line here."],
            ["Operation Name"],
            ["LeadTrack01_F_Tacops", true]
        ]],
        ["UAV", player]
    ] call SAS_Intro_fnc_play;
    [] call SAS_Intro_fnc_infoText;
};
```

---

## Next steps

| Feature | Module | README |
|---------|--------|--------|
| Gunship CAS support | `SAS_Gunship_fnc_` | [gunship/README.md](gunship/README.md) |
| Fast-rope insertion | `SAS_Fastrope_fnc_` | [fastrope/README.md](fastrope/README.md) |
| Hostages | `SAS_Hostage_fnc_` | [hostage/README.md](hostage/README.md) |
| Captive / surrender system | `SAS_Captive_fnc_` | [captive/README.md](captive/README.md) |
| Drag incapacitated players | `SAS_DragBody_fnc_` | [dragbody/README.md](dragbody/README.md) |
| Morale and reinforcements | `SAS_Morale_fnc_` / `SAS_Reinforcement_fnc_` | [morale/README.md](morale/README.md) |
| Night ops (lights, flares) | `SAS_NightOps_fnc_` | [nightops/README.md](nightops/README.md) |
| Intel collectibles | `SAS_Intel_fnc_` | [intel/README.md](intel/README.md) |

Full module list: [README.md](README.md)
