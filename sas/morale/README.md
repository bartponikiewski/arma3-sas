# SAS Morale Module

This module provides group-level morale and fear calculations for Arma 3 missions using the SAS framework.

## Features
- Tracks casualties for each group
- Calculates group fear based on casualties, suppression, and morale
- Emits `SAS_Morale_groupFearChanged` events when group fear changes
- Supports event-driven updates via Arma 3's event handler system

## Usage
1. **Register a group:**
   ```sqf
   [group player] call SAS_Morale_fnc_registerGroup;
   [player] call SAS_Morale_fnc_registerGroup;
   ```
   This sets up morale tracking and event handlers for the group.

2. **Fear calculation:**
   ```sqf
   [group player] call SAS_Morale_fnc_calculateGroupFear;
   ```
   Returns a value between 0 (no fear) and 1 (maximum fear).

3. **Event handling:**
   - The module emits a `SAS_Morale_groupFearChanged` event using `BIS_fnc_callScriptedEventHandler` whenever group fear changes.
   - You can listen for this event in your scripts:
     ```sqf
     _group addEventHandler ["SAS_Morale_groupFearChanged", {
         params ["_group", "_oldFear", "_newFear"];
         // Custom logic here
     }];
     ```

## Implementation Notes
- Casualties are tracked as an array of killed units in the group variable `SAS_Morale_casualties`.
- Fear is stored in the group variable `SAS_Morale_groupFear`.
- Suppression and low morale are calculated per alive unit.
- If all alive units are suppressed or have low morale, fear is weighted to be high.
- If only one unit remains and has low morale, fear is set to maximum.

## File Overview
- `fn_registerGroup.sqf`: Registers a group for morale tracking and sets up event handlers.
- `fn_onUnitKilled.sqf`: Handles unit killed events, updates casualties, recalculates fear, and emits events.
- `fn_calculateGroupFear.sqf`: Calculates group fear based on current group state.
- `fn_groupFearChanged.sqf`: Custom logic for when group fear changes (can be extended).

## Extending
- You can add custom effects, notifications, or AI logic in `fn_groupFearChanged.sqf`.
- Adjust weights in `fn_calculateGroupFear.sqf` for different mission balancing.
