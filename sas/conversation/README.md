
# SAS Conversation Module

This module provides functions for displaying in-game conversation overlays and dialogue dialogs in Arma 3 missions using the SAS framework. Key features include speaker overlays, face-cam, and branching dialogue.

## Key Functions

### Message Overlay
**SAS_Conv_fnc_message**

Displays a non-modal, non-pausing conversation overlay at the bottom of the screen. Auto-closes after a configurable duration.

**Usage:**
```
[speaker, face, dialogue, duration] call SAS_Conv_fnc_message;
```

**Parameters:**
- speaker: Speaker name shown in the name bar
- face: Unit for live PiP face-cam or path to static portrait image
- dialogue: Dialogue text shown in the body
- duration: Seconds before overlay auto-closes (default: 4)

---

### Dialogue Dialog
**SAS_Conv_fnc_messageDialog**

Displays a modal dialogue dialog with response buttons for interactive NPC conversations.

**Usage:**
```
[speaker, face, dialogue, responses] call SAS_Conv_fnc_messageDialog;
```

---

## Usage Example
```sqf
["Radio", "", "All units, stand by."] call SAS_Conv_fnc_message;
["Sgt. Harris", _npc, "Move up to the ridge. Now.", 6] call SAS_Conv_fnc_message;
```

## Debugging
Enable `SAS_Debug_global` for debug output. All debug messages use `SAS_fnc_logDebug`.

## Standards
Follow [copilot-instructions.md](../.github/copilot-instructions.md) for documentation and coding conventions.
```

---

### `SAS_Conv_fnc_messageDialog`
Displays a modal conversation dialog with speaker name, optional face/portrait, dialogue text, and response buttons. Supports fully inline branching dialogue trees.

**Usage:**
```sqf
[speaker, face, dialogue, responses] call SAS_Conv_fnc_messageDialog;
```

**Parameters:**
| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | STRING | Speaker name shown in the name bar | `""` |
| 1 | OBJECT \| STRING | Unit for live PiP face-cam, or portrait path | `""` |
| 2 | STRING | Dialogue text spoken by the NPC | `""` |
| 3 | ARRAY | Array of `[label, action]` response definitions. `action` can be CODE or an ARRAY for the next node | `[["Close", {}]]` |

**Returns:** `DISPLAY` — reference to the created display, or `displayNull` on failure.

**Examples:**
```sqf
// 1. Minimal - one line, no portrait
["Sgt. Harris", "", "Stay sharp. They know we're here."] call SAS_Conv_fnc_messageDialog;

// 2. Live face-cam with response buttons
["Sgt. Harris", _npc, "The LZ is hot. What are your orders?",
    [
        ["Push through", { hint "Pushing through!"; }],
        ["Fall back",    { hint "Falling back."; }]
    ]
] call SAS_Conv_fnc_messageDialog;

// 3. Chained dialogue nodes (live-cam unit auto-forwarded)
["Intel Officer", _npc, "Two extraction options. Which do you want?",
    [
        ["Northern route", [
            "Intel Officer", _npc, "4km on foot. Light resistance.",
            [["Take it", { hint "Northern selected."; }]]
        ]],
        ["Southern route", [
            "Intel Officer", _npc, "vehicle-friendly but exposed.",
            [["Take it", { hint "Southern selected."; }]]
        ]]
    ]
] call SAS_Conv_fnc_messageDialog;
```

---

### Cinematic Subtitles with Voiceover
**SAS_Conv_fnc_subtitle**

Displays Apex-style cinematic subtitles via `BIS_fnc_EXP_camp_playSubtitles` with optional voice audio playback. Supports a single audio track over the whole sequence or per-entry audio. Must be called via `spawn`.

**Usage:**
```sqf
[sequence, sound, source] spawn SAS_Conv_fnc_subtitle;
```

**Parameters:**
| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | ARRAY | Array of subtitle entries: `[speaker, text, timing]` or `[speaker, text, timing, sound, source]` | `[]` |
| 1 | STRING | (Optional) CfgSounds class for a single audio track over the entire sequence | `""` |
| 2 | OBJECT | (Optional) Unit for say3D for the global track, objNull for playSound | `objNull` |

**Examples:**
```sqf
// Single audio track over entire subtitle sequence
[
    [
        ["Harris", "Contact front! Get to cover!", 0],
        ["Harris", "Davis, flank left!",           4],
        ["Harris", "Moving up now.",               8]
    ],
    "SAS_vo_harris_briefing",
    _harris
] spawn SAS_Conv_fnc_subtitle;

// Per-entry audio (different voice per line)
[
    [
        ["Harris", "Contact front!", 0, "SAS_vo_harris_line1", _harris],
        ["Davis",  "I see them!",    4, "SAS_vo_davis_line1",  _davis],
        ["Harris", "Move up.",       8]
    ]
] spawn SAS_Conv_fnc_subtitle;

// Text-only (no audio)
[
    [
        ["Command", "All callsigns, report status.", 0]
    ]
] spawn SAS_Conv_fnc_subtitle;
```

**Cancellation:**
```sqf
BIS_fnc_EXP_camp_playSubtitles_terminate = true;
```

**CfgSounds:** Voice lines must be defined in `CfgSounds` in `description.ext`. Example:
```cpp
class CfgSounds
{
    sounds[] = {};
    class SAS_vo_harris_briefing
    {
        name = "SAS_vo_harris_briefing";
        sound[] = {"sas\voice\harris_briefing.ogg", db+0, 1.0};
        titles[] = {};
    };
};
```

---

## Implementation Notes
- All functions require `hasInterface` — they exit silently on dedicated servers.
- The `message` function overlays controls directly on display 46 (the default HUD display) and spawns a cleanup thread to remove them after `_duration` seconds.
- The `messageDialog` function uses `createDialog "SAS_RscGuiMessage"` (IDD 9001 defined in `description.ext`).
- When a unit OBJECT is passed as `face`, a PiP camera is created at the unit's head bone and streamed into the portrait area. The camera is destroyed on dialog close via the `Unload` event handler.
- Response button actions are stored in a display variable (`SAS_Conv_messageDialogGuiActionMap`) to avoid scoping issues inside event handlers.
- Up to 3 response buttons are shown per row; additional responses wrap to new rows.
- The `subtitle` function wraps `BIS_fnc_EXP_camp_playSubtitles` and schedules audio via `say3D` or `playSound` timed to each entry. Voice lines are defined in `CfgSounds` in `description.ext`.

## Debugging
All functions use `SAS_fnc_logDebug` for debug output. Enable `SAS_Debug_global` for verbose logs.

## References
- See [copilot-instructions.md](../../.github/copilot-instructions.md) for architectural and coding standards.
- See `sas/common/gui` for the simpler `SAS_fnc_guiMessage` dialog (no portrait, no face-cam).
