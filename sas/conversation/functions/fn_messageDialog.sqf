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
    1: (Optional) OBJECT - Unit whose face is streamed via PiP camera (default: objNull)
                 | STRING - Path to a static portrait image, "" for none (default: "")
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
    ["Sgt. Harris", "", "Stay sharp. They know we're here."] call SAS_Conv_fnc_messageDialog;

    // 2. Live face cam from a unit object
    private _npc = grpNull; // replace with actual unit reference
    ["Sgt. Harris", _npc, "The LZ is hot. What are your orders?",
        [
            ["Push through", { hint "Pushing through the hot zone!"; }],
            ["Fall back",    { hint "Falling back to rally point."; }]
        ]
    ] call SAS_Conv_fnc_messageDialog;

    // 3. Static portrait image (legacy)
    [
        "Lt. Vasquez",
        "portraits\vasquez.paa",
        "Command wants us to secure the compound before dawn. Understood?",
        [["Understood", {}]]
    ] call SAS_Conv_fnc_messageDialog;

    // 4. Chained nodes with live face cam - unit reference auto-forwarded
    [
        "Intel Officer",
        _npc,
        "We have two extraction options. Which do you want details on?",
        [
            ["Northern route", [
                "Intel Officer",
                _npc,
                "Northern route: 4km on foot through the forest. Light resistance expected.",
                [
                    ["Take it", { hint "Northern route selected."; }],
                    ["Back",    []]
                ]
            ]],
            ["Southern route", [
                "Intel Officer",
                _npc,
                "Southern route: vehicle-friendly but exposed. Move fast.",
                [
                    ["Take it", { hint "Southern route selected."; }],
                    ["Cancel",  {}]
                ]
            ]]
        ]
    ] call SAS_Conv_fnc_messageDialog;

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params [
    ["_speaker",   "",      [""]],
    ["_face",      "",      ["", objNull]],  // STRING = portrait path | OBJECT = unit for live cam
    ["_dialogue",  "",      [""]],
    ["_responses", [["Close", {}]], [[]]]
];

if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

// Resolve whether _face is a unit or a static portrait path
private _unit     = objNull;
private _portrait = "";
if (_face isEqualType objNull) then {
    _unit = _face;
} else {
    _portrait = _face;
};

// -------------------------------------------------------
// Layout constants (SafeZone-relative units)
// -------------------------------------------------------
private _padding     = 0.012;
private _nameBarH    = 0.038;
private _portraitW   = 0.10;
private _portraitH   = 0.10;
private _dialogueH   = _portraitH;          // text area matches portrait height
private _btnH        = 0.042;
private _btnRows     = ceil ((count _responses) / 3);  // wrap every 3 responses
private _btnAreaH    = (_btnH * _btnRows) + (_padding * (_btnRows - 1));
private _dialogW     = 0.56;
private _dialogH     = _nameBarH + _dialogueH + _btnAreaH + (_padding * 5);

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
["[SAS_Conv_fnc_messageDialog] Opening - Speaker: '" + _speaker + "' | Face unit: " + (if (isNull _unit) then { "none" } else { str _unit }) + " | Portrait: '" + _portrait + "' | Responses: " + str (count _responses)] call SAS_fnc_logDebug;

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
_nameBar ctrlSetText _speaker;
_nameBar ctrlSetTextColor [1.0, 0.90, 0.60, 1.0];
_nameBar ctrlCommit 0;

// -------------------------------------------------------
// Face area (left panel) - live cam OR static portrait
// -------------------------------------------------------
private _contentY    = _dialogY + _nameBarH + _padding;
private _textOffsetX = _padding;  // default: no face panel, text uses full width

if (!isNull _unit) then {
    // --- Live face camera (PiP) ---
    // Unique rendertarget name per call prevents multiple dialog instances
    // from sharing and corrupting each other's "rtt" slot.
    private _rttName = "sas_conv_rtt_" + str (floor (diag_tickTime * 1000));

    private _headPos = _unit modelToWorldVisual (_unit selectionPosition "head");
    _headPos set [2, _headPos select 2 + 0.5]; // shift target up to face centre
    private _localOffset = [0, 0.3, 0.09];
    private _camPos = _headPos vectorAdd (_unit vectorModelToWorld _localOffset);

    private _cam = "camera" camCreate _camPos;
    _cam camSetTarget _unit;
    _cam camSetRelPos [0, 0.5, 1.5];
    _cam cameraEffect ["internal", "back", _rttName];
    _cam camCommit 1;
    _rttName setPiPEffect [0];

    private _faceCtrl = _display ctrlCreate ["RscPicture", 9102];
    _faceCtrl ctrlSetPosition [_dialogX + _padding, _contentY, _portraitW, _portraitH];
    _faceCtrl ctrlSetText format ["#(argb,512,512,1)r2t(%1,1.0)", _rttName];
    _faceCtrl ctrlCommit 0;

    _textOffsetX = _portraitW + (_padding * 2);

    // Store both cam and rtt name for cleanup
    _display setVariable ["SAS_Conv_messageDialogGuiCam", _cam];
    _display setVariable ["SAS_Conv_messageDialogGuiRtt", _rttName];
    _display displayAddEventHandler ["Unload", {
        params ["_disp"];
        private _c = _disp getVariable ["SAS_Conv_messageDialogGuiCam", objNull];
        if (!isNull _c) then {
            _c cameraEffect ["terminate", "back"];
            camDestroy _c;
        };
    }];

} else {
    if (_portrait != "") then {
        // --- Static portrait image ---
        private _portraitCtrl = _display ctrlCreate ["RscPicture", 9102];
        _portraitCtrl ctrlSetPosition [_dialogX + _padding, _contentY, _portraitW, _portraitH];
        _portraitCtrl ctrlSetText _portrait;
        _portraitCtrl ctrlCommit 0;
        _textOffsetX = _portraitW + (_padding * 2);
        ["[SAS_Conv_fnc_messageDialog] Static portrait loaded: " + _portrait] call SAS_fnc_logDebug;
    };
};

// -------------------------------------------------------
// Dialogue text (right of portrait, or full width)
// RscStructuredText: supports left-alignment and formatted
// text tags (<t>, <br/>, <img>, etc.)
// -------------------------------------------------------
private _textX = _dialogX + _textOffsetX;
private _textW = _dialogW - _textOffsetX - _padding;
private _innerPad = 0.008;  // small left margin inside text area

private _textCtrl = _display ctrlCreate ["RscStructuredText", 9103];
_textCtrl ctrlSetPosition [_textX + _innerPad, _contentY + _innerPad, _textW - (_innerPad * 2), _dialogueH - (_innerPad * 2)];
_textCtrl ctrlSetBackgroundColor [0.0, 0.0, 0.0, 0.0];
_textCtrl ctrlSetStructuredText parseText _dialogue;
_textCtrl ctrlSetTextColor [0.92, 0.92, 0.92, 1.0];
_textCtrl ctrlCommit 0;

// -------------------------------------------------------
// Divider line between dialogue and responses
// -------------------------------------------------------
private _divY = _contentY + _dialogueH + (_padding * 0.5);
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
["Conversations Log", _speaker, _dialogue] remoteExecCall ["SAS_Briefing_fnc_addDiaryRecord", 0];

// ["[SAS_Conv_fnc_messageDialog] Dialog ready with " + str (count _responses) + " response(s)"] call SAS_fnc_logDebug;

_display
