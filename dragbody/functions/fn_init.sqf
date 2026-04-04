/*
	Description:
	Initializes the drag body module on each player client.
	Auto-called via postInit = 1. Only activates when native revive is enabled.

	Broadcasts the player to all clients so each can add a "Drag" action to them.
	Uses the player object as JIP ID for automatic replay and disconnect cleanup.
*/

// Only run when native revive is enabled
if (getNumber (missionConfigFile >> "ReviveMode") == 0) exitWith {};

// Only run on player clients
if (!hasInterface) exitWith {};

[] spawn {
	waitUntil {!isNull player}; // Wait until player object is initialized


	// Initialize drag state
	player setVariable ["SAS_DragBody_isDragging", false, true];

	// Broadcast to all clients (current + JIP) — each client adds a drag action to this player
	[player] remoteExec ["SAS_DragBody_fnc_addDragAction", 0, player];

	// Re-init on respawn
	if (isNil "SAS_DragBody_respawnEH") then {
		SAS_DragBody_respawnEH = player addMPEventHandler ["MPRespawn", {
			params ["_unit", "_corpse"];
			_unit setVariable ["SAS_DragBody_isDragging", false, true];
			[_unit] remoteExec ["SAS_DragBody_fnc_addDragAction", 0, _unit];
		}];
	};
};
