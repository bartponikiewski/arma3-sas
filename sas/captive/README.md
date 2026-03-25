# Captive Module

Provides a full captive system for AI units: surrender, arrest, escort, vehicle transport, and release. State is broadcast globally via `remoteExec` with JIP support.

## Setup

Register units you want to be capturable:

```sqf
[[unit1, unit2, unit3]] call SAS_Captive_fnc_register;
```

Or force-surrender a unit directly (no prior registration needed):

```sqf
[someUnit] call SAS_Captive_fnc_surrender;
```

## State Machine

Units progress through these states:

```
CAPTURABLE → SURRENDERED → ARRESTED → ESCORTED → IN_VEHICLE
                                   ↘ RELEASED → CAPTURABLE
                                   ↘ NONE (full revert)
```

| State | Description |
|-------|-------------|
| `CAPTURABLE` | "Hands Up!" action is visible on the unit |
| `SURRENDERED` | Unit drops weapon, freezes, plays hands-up animation; "Arrest" action appears |
| `ARRESTED` | Hands-behind-back animation; "Escort" action appears |
| `ESCORTED` | Unit is attached in front of the escorting player; "Stop Escort" and "Load into Vehicle" actions active |
| `IN_VEHICLE` | Unit is in vehicle cargo; "Unload Captive" action on the vehicle |
| `RELEASED` | Unit is freed (still captive flag); re-capture possible |
| `NONE` | All AI and captive flags fully restored |

## Functions

| Function | Description |
|----------|-------------|
| `SAS_Captive_fnc_register` | Register an array of units as capturable |
| `SAS_Captive_fnc_setCaptiveState` | Core state machine — sets state and manages actions/animations globally |
| `SAS_Captive_fnc_surrender` | Force a unit directly into `SURRENDERED` state |
| `SAS_Captive_fnc_addSurrenderAction` | Add "Hands Up!" action to a unit |
| `SAS_Captive_fnc_removeSurrenderAction` | Remove "Hands Up!" action |
| `SAS_Captive_fnc_addArrestAction` | Add "Arrest" action to a surrendered unit |
| `SAS_Captive_fnc_removeArrestAction` | Remove "Arrest" action |
| `SAS_Captive_fnc_escort` | Start escorting an arrested unit (attach, walk lock, monitor loop) |
| `SAS_Captive_fnc_stopEscort` | Stop escorting and return unit to `ARRESTED` state |
| `SAS_Captive_fnc_addEscortAction` | Add "Escort" action to an arrested unit |
| `SAS_Captive_fnc_removeEscortAction` | Remove "Escort" action |
| `SAS_Captive_fnc_loadInVehicle` | Load an escorted captive into the nearest vehicle |
| `SAS_Captive_fnc_unloadFromVehicle` | Unload a captive from a vehicle |
| `SAS_Captive_fnc_removeUnloadAction` | Remove "Unload Captive" action from the vehicle |

## Variables

All variables are set globally (`true` broadcast) on the unit:

| Variable | Type | Description |
|----------|------|-------------|
| `SAS_Captive_state` | String | Current state of the unit |
| `SAS_Captive_escortedBy` | Object | Player currently escorting the unit |
| `SAS_Captive_vehicle` | Object | Vehicle the unit is loaded into |
| `SAS_Captive_killedEH` | Number | Event handler ID for cleanup on death |

## Notes

- Units already registered in the hostage system (`SAS_Hostage_state`) are skipped automatically.
- The escort monitor loop auto-releases if the escorting player is incapacitated or killed.
- JIP clients receive the current state and have visual/action state re-applied correctly.
- "Load into Vehicle" action only appears when the cursor targets a vehicle within 3m with free cargo.
