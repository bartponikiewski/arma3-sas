/*
    Description:
    Creates and displays a configurable GUI message dialog with dynamically
    generated buttons. The dialog is displayed on screen until the player
    clicks a button, at which point the associated action code is executed
    and the dialog is closed.

    Relies on the base dialog class "SAS_RscGuiMessage" (idd 9001) defined
    in description.ext. All controls are injected dynamically.

    Usage:
    [title, message, buttons] call SAS_Gui_fnc_guiMessage;

    Parameter(s):
    0: (Optional) STRING - Dialog title text (default: "Message")
    1: (Optional) STRING - Message body text (default: "")
    2: (Optional) ARRAY  - Array of button definitions. Each entry: [label, action]
                             label  : STRING - Text displayed on the button
                             action : CODE   - Code executed when the button is clicked
                           (default: [["OK", {}]])

    Returns:
    DISPLAY - Reference to the created display, or displayNull on failure

    Examples:
    // Simple OK dialog
    ["Notice", "Mission area is now active."] call SAS_Gui_fnc_guiMessage;

    // Custom single button
    ["Warning", "Proceed with caution.", [["Understood", {}]]] call SAS_Gui_fnc_guiMessage;

    // Multiple buttons with actions
    [
        "Retreat?",
        "Your squad is taking heavy fire. Fall back to extraction?",
        [
            ["Retreat", { hint "Retreating..."; }],
            ["Hold",    { hint "Holding position."; }],
            ["Cancel",  {}]
        ]
    ] call SAS_Gui_fnc_guiMessage;

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params [
    ["_title",   "Message", [""]],
    ["_message", "",        [""]],
    ["_buttons", [["OK", {}]], [[]]]
];

["[SAS_Gui_fnc_guiMessage] Creating dialog - Title: '" + _title + "' | Buttons: " + str (count _buttons)] call SAS_fnc_logDebug;

// -------------------------------------------------------
// Layout constants (SafeZone-relative units)
// -------------------------------------------------------
private _padding    = 0.012;
private _titleH     = 0.04;
private _msgMinH    = 0.08;
private _btnH       = 0.045;
private _dialogW    = 0.44;
private _dialogH    = _titleH + _msgMinH + _btnH + (_padding * 4);

private _dialogX    = safeZoneX + (safeZoneW - _dialogW) * 0.5;
private _dialogY    = safeZoneY + (safeZoneH - _dialogH) * 0.5;

// -------------------------------------------------------
// Open base dialog and obtain its display reference
// -------------------------------------------------------
createDialog "SAS_RscGuiMessage";
private _display = findDisplay 9001;

if (isNull _display) exitWith {
    ["[SAS_Gui_fnc_guiMessage] ERROR: Failed to open SAS_RscGuiMessage dialog"] call SAS_fnc_logDebug;
    displayNull
};

["[SAS_Gui_fnc_guiMessage] Display opened successfully"] call SAS_fnc_logDebug;

// -------------------------------------------------------
// Background panel
// -------------------------------------------------------
private _bg = _display ctrlCreate ["RscText", 9100];
_bg ctrlSetPosition [_dialogX, _dialogY, _dialogW, _dialogH];
_bg ctrlSetBackgroundColor [0.08, 0.08, 0.10, 0.92];
_bg ctrlCommit 0;

// -------------------------------------------------------
// Title bar
// -------------------------------------------------------
private _titleBar = _display ctrlCreate ["RscText", 9101];
_titleBar ctrlSetPosition [_dialogX, _dialogY, _dialogW, _titleH];
// _titleBar ctrlSetBackgroundColor [0.15, 0.25, 0.50, 0.95];
_titleBar ctrlSetText _title;
_titleBar ctrlSetTextColor [1.0, 1.0, 1.0, 1.0];
_titleBar ctrlCommit 0;

// -------------------------------------------------------
// Message body
// -------------------------------------------------------
private _msgY = _dialogY + _titleH + _padding;
private _msgH = _dialogH - _titleH - _btnH - (_padding * 3);

private _msgCtrl = _display ctrlCreate ["RscText", 9102];
_msgCtrl ctrlSetPosition [_dialogX + _padding, _msgY, _dialogW - (_padding * 2), _msgH];
_msgCtrl ctrlSetBackgroundColor [0.0, 0.0, 0.0, 0.0];
_msgCtrl ctrlSetText _message;
_msgCtrl ctrlSetTextColor [0.90, 0.90, 0.90, 1.0];
_msgCtrl ctrlCommit 0;

// -------------------------------------------------------
// Buttons - evenly distributed in a single horizontal row
// -------------------------------------------------------
private _btnCount   = count _buttons;
private _btnAreaW   = _dialogW - (_padding * 2);
private _btnSpacing = 0.006;
private _btnW       = (_btnAreaW - (_btnSpacing * (_btnCount - 1))) / _btnCount;
private _btnY       = _dialogY + _dialogH - _btnH - _padding;

// Store button actions keyed by IDC on the display for safe retrieval
// inside the event handler scope (event handler code runs in a fresh scope)
private _actionMap = createHashMap;

{
    _x params ["_btnLabel", ["_btnAction", {}]];

    private _btnX   = _dialogX + _padding + (_forEachIndex * (_btnW + _btnSpacing));
    private _btnIDC = 9200 + _forEachIndex;

    _actionMap set [str _btnIDC, _btnAction];

    private _btn = _display ctrlCreate ["RscButton", _btnIDC];
    _btn ctrlSetPosition [_btnX, _btnY, _btnW, _btnH];
    _btn ctrlSetText _btnLabel;
    _btn ctrlCommit 0;

    _btn ctrlAddEventHandler ["ButtonClick", {
        params ["_control"];
        private _idc      = ctrlIDC _control;
        private _disp     = ctrlParent _control;
        private _actMap   = _disp getVariable ["SAS_guiMsgActionMap", createHashMap];
        private _act      = _actMap getOrDefault [str _idc, {}];
        _disp closeDisplay 0;
        [] call _act;
    }];

    ["[SAS_Gui_fnc_guiMessage] Button created - IDC: " + str _btnIDC + " Label: '" + _btnLabel + "'"] call SAS_fnc_logDebug;
} forEach _buttons;

// Attach action map to display for event handler retrieval
_display setVariable ["SAS_guiMsgActionMap", _actionMap];

["[SAS_Gui_fnc_guiMessage] Dialog ready with " + str _btnCount + " button(s)"] call SAS_fnc_logDebug;

_display
