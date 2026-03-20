/*
    Description:
    Creates and displays a conversation dialog featuring a speaker name,
    an optional portrait or live unit face camera, dialogue text, and
    configurable response buttons. Designed for NPC dialogue trees and
    branching conversations.

    When a unit OBJECT is passed as param 1, a local PiP camera is spawned,
    attached to the unit's head bone, and streamed into the portrait area as
    a live face cam. The camera is automatically cleaned up when the dialog
    closes. When chaining to the next node via an ARRAY response, the unit
    reference is forwarded automatically so the face cam persists.

    When a STRING is passed as param 1, it is treated as a static portrait
    image path (legacy behaviour).

    Response buttons can chain directly into the next conversation node by
    passing an ARRAY as the action instead of CODE. The dialog closes and
    immediately reopens with the next node's data, enabling fully inline
    dialogue trees without external scripting.

    Relies on the base dialog class "SAS_RscGuiMessage" (idd 9001) defined
    in description.ext. All controls are injected dynamically.

    Usage:
    [speaker, face, dialogue, responses] call SAS_Conv_fnc_messageDialogDialog;

    Parameter(s):
    0: (Optional) STRING - Speaker name shown in the name bar (default: "")
    2: (Optional) STRING - Dialogue text spoken by the NPC (default: "")
    3: (Optional) ARRAY  - Array of player response definitions. Each entry: [label, action]
                             label  : STRING      - Text shown on the response button
                             action : CODE        - Executed when chosen, dialog closes first
                                    | ARRAY       - Next conversation node params
                                                    [speaker, face, dialogue, responses]
                                                    Dialog closes and reopens with next node.
                                                    The current unit is automatically forwarded
                                                    when param 1 was an OBJECT.
                           (default: [["[End]", {}]])

    Returns:
    DISPLAY - Reference to the created display, or displayNull on failure

    Examples:
    // 1. Minimal - NPC says one line, no portrait
    ["Intel", "Stay sharp. They know we're here.", [
            ["Take", { hint "Taking intel"; }],
            ["Destroy",    { hint "Destroying intel"; }]
    ]] call SAS_Intel_fnc_intelDialog;

    

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params [
    ["_title",   "",      [""]],
    ["_intelText",  "",      [""]],
    ["_responses", [["Close", {}]], [[]]]
];

if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

// Resolve whether _face is a unit or a static portrait path
private _unit     = objNull;

// -------------------------------------------------------
// Layout constants (SafeZone-relative units)
// -------------------------------------------------------
private _padding     = 0.012;
private _nameBarH    = 0.038;
private _portraitW   = 0.10;
private _portraitH   = 0.10;
private _intelTextH   = _portraitH;          // text area matches portrait height
private _btnH        = 0.042;
private _btnRows     = ceil ((count _responses) / 3);  // wrap every 3 responses
private _btnAreaH    = (_btnH * _btnRows) + (_padding * (_btnRows - 1));
private _dialogW     = 0.56;
private _dialogH     = _nameBarH + _intelTextH + _btnAreaH + (_padding * 5);

private _dialogX     = safeZoneX + (safeZoneW - _dialogW) * 0.5;
// Place dialog in lower third of screen (conversation style)
private _dialogY     = safeZoneY + safeZoneH * 0.62;

private _bgColor = [
profilenamespace getVariable ['GUI_BCG_RGB_R', 0.05],
profilenamespace getVariable ['GUI_BCG_RGB_G', 0.05],
profilenamespace getVariable ['GUI_BCG_RGB_B', 0.07],
profilenamespace getVariable ['GUI_BCG_RGB_A', 0.88]
];


// -------------------------------------------------------
// Open base dialog and obtain its display reference
// Note: SAS_fnc_logDebug uses hint, which is hidden behind the dialog
// while it is open and only becomes visible after it closes.
// Log before createDialog so the message fires visibly.
// -------------------------------------------------------
createDialog "SAS_RscGuiMessage";
private _display = findDisplay 9001;

if (isNull _display) exitWith {
    ["[SAS_Conv_fnc_messageDialog] ERROR: Failed to open SAS_RscGuiMessage dialog"] call SAS_fnc_logDebug;
    displayNull
};

// Intercept Escape key - without this the engine fires ButtonClick on the
// last focused RscButton as a default 'cancel' action when ESC is pressed.
_display displayAddEventHandler ["KeyDown", {
    params ["_disp", "_key"];
    if (_key == 1) then {   // DIK_ESCAPE = 1
        _disp closeDisplay 0;
        true                // consume event, prevent engine default
    };
}];

// -------------------------------------------------------
// Background panel
// -------------------------------------------------------
private _bg = _display ctrlCreate ["RscText", 9100];
_bg ctrlSetPosition [_dialogX, _dialogY, _dialogW, _dialogH];
_bg ctrlSetBackgroundColor [0.05, 0.05, 0.07, 0.94];
_bg ctrlCommit 0;

// -------------------------------------------------------
// Speaker name bar
// -------------------------------------------------------
private _nameBar = _display ctrlCreate ["RscText", 9101];
_nameBar ctrlSetPosition [_dialogX, _dialogY, _dialogW, _nameBarH];
_nameBar ctrlSetBackgroundColor _bgColor;
_nameBar ctrlSetText _title;
_nameBar ctrlSetTextColor [1.0, 0.90, 0.60, 1.0];
_nameBar ctrlCommit 0;

private _contentY    = _dialogY + _nameBarH + _padding;
private _textOffsetX = _padding;  // default: no face panel, text uses full width


// -------------------------------------------------------
// Dialogue text (right of portrait, or full width)
// RscStructuredText: supports left-alignment and formatted
// text tags (<t>, <br/>, <img>, etc.)
// -------------------------------------------------------
private _textX = _dialogX + _textOffsetX;
private _textW = _dialogW - _textOffsetX - _padding;
private _innerPad = 0.008;  // small left margin inside text area

private _textCtrl = _display ctrlCreate ["RscStructuredText", 9103];
_textCtrl ctrlSetPosition [_textX + _innerPad, _contentY + _innerPad, _textW - (_innerPad * 2), _intelTextH - (_innerPad * 2)];
_textCtrl ctrlSetBackgroundColor [0.0, 0.0, 0.0, 0.0];
_textCtrl ctrlSetStructuredText parseText _intelText;
_textCtrl ctrlSetTextColor [0.92, 0.92, 0.92, 1.0];
_textCtrl ctrlCommit 0;

// -------------------------------------------------------
// Divider line between dialogue and responses
// -------------------------------------------------------
private _divY = _contentY + _intelTextH + (_padding * 0.5);
private _divider = _display ctrlCreate ["RscText", 9104];
_divider ctrlSetPosition [_dialogX + _padding, _divY, _dialogW - (_padding * 2), 0.002];
_divider ctrlSetBackgroundColor _bgColor;
_divider ctrlCommit 0;

// -------------------------------------------------------
// Response buttons - up to 3 per row, wrapping downward
// -------------------------------------------------------
private _btnAreaY   = _divY + (_padding * 1.5);
private _maxPerRow  = 3;
private _btnAreaW   = _dialogW - (_padding * 2);
private _btnSpacing = 0.006;

// Store response actions keyed by IDC for event handler retrieval
private _actionMap = createHashMap;

{
    _x params ["_responseLabel", ["_responseAction", {}]];

    private _col    = _forEachIndex mod _maxPerRow;
    private _row    = floor (_forEachIndex / _maxPerRow);  // floor: integer row index
    // Last row may have fewer buttons - recalculate width so they stay left-aligned
    private _rowCount = (count _responses) - (_row * _maxPerRow);
    if (_rowCount > _maxPerRow) then { _rowCount = _maxPerRow; };
    private _btnW   = (_btnAreaW - (_btnSpacing * (_rowCount - 1))) / _rowCount;

    private _btnX   = _dialogX + _padding + (_col * (_btnW + _btnSpacing));
    private _btnY   = _btnAreaY + (_row * (_btnH + _padding));
    private _btnIDC = 9200 + _forEachIndex;

    _actionMap set [str _btnIDC, _responseAction];

    private _btn = _display ctrlCreate ["RscButton", _btnIDC];
    _btn ctrlSetPosition [_btnX, _btnY, _btnW, _btnH];
    _btn ctrlSetText _responseLabel;
    _btn ctrlCommit 0;

    _btn ctrlAddEventHandler ["ButtonClick", {
        params ["_control"];
        private _idc     = ctrlIDC _control;
        private _disp    = ctrlParent _control;
        private _actMap  = _disp getVariable ["SAS_Conv_messageDialogGuiActionMap", createHashMap];
        private _act     = _actMap getOrDefault [str _idc, {}];
        // Retrieve the current unit so it can be forwarded to chained nodes
        private _curUnit = _disp getVariable ["SAS_Conv_messageDialogGuiUnit", objNull];
        _disp closeDisplay 0;
        // If action is ARRAY, treat as next conversation node params
        if (_act isEqualType []) then {
            // Forward the live-cam unit: if the next node has no face set (index 1
            // is an empty string), inject the current unit so the cam persists.
            if ((count _act >= 2) && { (_act select 1) isEqualTo "" } && { !isNull _curUnit }) then {
                _act set [1, _curUnit];
            };
            _act call SAS_Conv_fnc_messageDialog;
        } else {
            [] call _act;
        };
    }];

   // ["[SAS_Conv_fnc_messageDialog] Response created - IDC: " + str _btnIDC + " Label: '" + _responseLabel + "'"] call SAS_fnc_logDebug;
} forEach _responses;

// Attach action map and unit reference to display for event handler retrieval
_display setVariable ["SAS_Conv_messageDialogGuiActionMap", _actionMap];
_display setVariable ["SAS_Conv_messageDialogGuiUnit", _unit];

// Add diary record with conversation log.
["Intel Log", _title, _intelText] remoteExecCall ["SAS_Briefing_fnc_addDiaryRecord", 0];

// ["[SAS_Conv_fnc_messageDialog] Dialog ready with " + str (count _responses) + " response(s)"] call SAS_fnc_logDebug;

_display
