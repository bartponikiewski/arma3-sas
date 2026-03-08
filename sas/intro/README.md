# SAS Intro Module

Provides intro sequence tools for Arma 3 missions: full screen text sequences, UAV establishing shots, info overlays, and the Arma 3 quote screen.

## Features

- Full blackout intro with scrolling text lines and formatted title cards
- UAV/establishing shot camera with automatic day/night mode detection
- Bottom-right info overlay showing player name, location, date, and time
- Arma 3 EPA-style random quote screen

## Functions

### `SAS_Intro_fnc_opening`

Full intro sequence. Blacks out the screen, plays optional music, displays text lines one by one, then shows a formatted title card. Applies dynamic blur and fades back in at the end.

```sqf
[
    ["Line one of the intro.", "Line two of the intro."],  // text lines
    ["Operation Silent Strike", "3rd SAS Regiment"],       // title lines
    "MyMusicClass",                                        // music (optional)
    true,                                                  // black out (optional)
    true,                                                  // black in (optional)
    { hint "Intro finished"; }                             // callback (optional)
] spawn SAS_Intro_fnc_opening;
```

**Parameters:**

| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | `ARRAY` | Text lines to display sequentially | `[]` |
| 1 | `ARRAY` | Title lines shown after the text (first line large, subsequent smaller) | `[]` |
| 2 | `STRING` | Music class name to play | `""` |
| 3 | `BOOL` | Black out screen at start | `true` |
| 4 | `BOOL` | Fade back in at end with blur effect | `true` |
| 5 | `CODE` | Callback executed before black-in | `{}` |

**Notes:**
- Must be called with `spawn` — internally uses `sleep` and `waitUntil`.
- Display time per line is calculated as `(charCount * 0.08) max 4` seconds.
- Title lines are formatted with decreasing font sizes: large (`RobotoCondensedBold`), medium, small.

---

### `SAS_Intro_fnc_uav`

Plays a UAV/establishing shot using `BIS_fnc_establishingShot`. Automatically selects Normal or NVG camera mode based on time of day, or accepts a manual override.

```sqf
// Auto mode, fly over player
[] call SAS_Intro_fnc_uav;

// Fly over an object with custom text
[myObject, "Stratis - 0300 hrs"] call SAS_Intro_fnc_uav;

// Force NVG mode
[getPos myMarker, "LZ Delta", "NVG"] call SAS_Intro_fnc_uav;
```

**Parameters:**

| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | `OBJECT\|ARRAY` | Target object or world position | `player` |
| 1 | `STRING` | Text displayed during the shot | `""` |
| 2 | `STRING` | Camera mode: `"Auto"`, `"Normal"`, `"TI"`, `"NVG"` | `"Auto"` |

---

### `SAS_Intro_fnc_infoText`

Displays a bottom-right info overlay with player name, nearest locality, date, and time using `BIS_fnc_typeText`. Optionally adds cinema borders.

```sqf
// Defaults: player name + auto location
[] call SAS_Intro_fnc_infoText;

// Custom lines with cinema borders
["Cpl. Kowalski", "Airfield Delta", true] call SAS_Intro_fnc_infoText;
```

**Parameters:**

| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | `STRING` | First info line (name/unit) | Player name |
| 1 | `STRING` | Second info line (location) | Nearest locality |
| 2 | `BOOL` | Show cinema borders | `false` |

---

### `SAS_Intro_fnc_quote`

Displays a random Arma 3 EPA campaign quote video using `BIS_fnc_quotations`. Skips on dedicated servers.

```sqf
[] call SAS_Intro_fnc_quote;
```

---

## Typical Intro Sequence

```sqf
// 1. Show quote screen
[] call SAS_Intro_fnc_quote;

// 2. UAV fly-over
[player, "Stratis - Operation Silent Strike"] call SAS_Intro_fnc_uav;

// 3. Full opening sequence
[
    ["Intelligence reports enemy activity near the airfield.", "Your team has been inserted under cover of darkness."],
    ["Operation Silent Strike"],
    "MyIntroMusic"
] spawn SAS_Intro_fnc_opening;

// 4. Info overlay
["Cpl. Kowalski - 3rd SAS", "Stratis Airfield"] call SAS_Intro_fnc_infoText;
```

## File Overview

| File | Function | Description |
|------|----------|-------------|
| `fn_opening.sqf` | `SAS_Intro_fnc_opening` | Full blackout intro with text lines and title card |
| `fn_uav.sqf` | `SAS_Intro_fnc_uav` | UAV/establishing shot camera |
| `fn_infoText.sqf` | `SAS_Intro_fnc_infoText` | Bottom-right player/location/time overlay |
| `fn_quote.sqf` | `SAS_Intro_fnc_quote` | Random Arma 3 EPA quote screen |

## Debugging

All functions log debug output through `SAS_fnc_logDebug` when `SAS_Debug_global = true`.

## References

- See [copilot-instructions.md](../../.github/copilot-instructions.md) for coding standards.
- [`BIS_fnc_typeText`](https://community.bistudio.com/wiki/BIS_fnc_typeText)
- [`BIS_fnc_establishingShot`](https://community.bistudio.com/wiki/BIS_fnc_establishingShot)
- [`BIS_fnc_quotations`](https://community.bistudio.com/wiki/BIS_fnc_quotations)
