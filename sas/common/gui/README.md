# SAS Common — GUI Sub-module

This sub-module provides a generic, reusable GUI message dialog for the SAS framework. It supports a title bar, a message body, and one or more configurable action buttons — suitable for notifications, confirmations, and simple decision prompts.

## Functions

### `SAS_fnc_guiMessage`
Creates and displays a centered modal dialog with a title, message body, and a row of buttons. Each button executes a code block when clicked and then closes the dialog.

**Usage:**
```sqf
[title, message, buttons] call SAS_fnc_guiMessage;
```

**Parameters:**
| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | STRING | Dialog title text | `"Message"` |
| 1 | STRING | Message body text | `""` |
| 2 | ARRAY | Array of `[label, action]` button definitions. `action` is CODE executed on click. | `[["OK", {}]]` |

**Returns:** `DISPLAY` — reference to the created display, or `displayNull` on failure.

**Examples:**
```sqf
// Simple notification
["Notice", "Mission area is now active."] call SAS_fnc_guiMessage;

// Confirmation with custom button
["Warning", "Proceed with caution.", [["Understood", {}]]] call SAS_fnc_guiMessage;

// Multi-button decision
[
    "Retreat?",
    "Your squad is taking heavy fire. Fall back to extraction?",
    [
        ["Retreat", { hint "Retreating..."; }],
        ["Hold",    { hint "Holding position."; }],
        ["Cancel",  {}]
    ]
] call SAS_fnc_guiMessage;
```

## Implementation Notes
- The dialog relies on the `SAS_RscGuiMessage` base class (IDD 9001) defined in `description.ext`. All controls are injected dynamically.
- Buttons are laid out in a single evenly-spaced horizontal row.
- Button actions are stored in the display variable `SAS_guiMsgActionMap` (a `HashMap`) to safely bridge the event handler scope.
- The dialog is modal — it pauses player input until a button is clicked.

## Debugging
Debug output is controlled by `SAS_Debug_global`. Enable it to receive hint messages for each dialog lifecycle event and button creation.

## References
- See [copilot-instructions.md](../../../.github/copilot-instructions.md) for architectural and coding standards.
- For a non-modal conversation overlay with portrait/face-cam support, see `sas/conversation`.
