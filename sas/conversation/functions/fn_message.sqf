/*
    Description:
    Message in the original 'messageDialog' style but non-modal and
    non-pausing. Includes speaker name, optional portrait or live unit
    face-cam PiP, and a dialogue body on a semi-transparent background.
    There are NO response buttons — the overlay auto-closes after
    `_duration` seconds.

    Usage:
    [speaker, face, dialogue, responses, duration] call SAS_Conv_fnc_message;

    Parameter(s):
    0: (Optional) STRING - Speaker name shown in the name bar (default: "")
    1: (Optional) OBJECT - Unit whose face is streamed via PiP camera (default: objNull)
                 | STRING - Path to a static portrait image, "" for none (default: "")
    2: (Optional) STRING - Dialogue text shown in the body (default: "")
    3: (Optional) NUMBER - Duration in seconds before the overlay closes (default: 4)

    Returns:
    display - The created display reference, or displayNull on failure.
*/

params [
    ["_speaker",   "",      [""]],
    ["_face",      "",      ["", objNull]],  // STRING = portrait path | OBJECT = unit for live cam
    ["_dialogue",  "",      [""]],
    ["_duration",  4,        [4]]
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
// Layout constants (wider, placed at bottom)
// -------------------------------------------------------
private _padding     = 0.012;
private _nameBarH    = 0.038;
private _portraitW   = 0.12;
private _portraitH   = 0.12;
private _dialogueH   = _portraitH;          // text area matches portrait height
private _dialogW     = safeZoneW * 0.3;
private _dialogX     = safeZoneX + (safeZoneW - _dialogW) * 0.5;
// Place dialog near the bottom of the screen
private _dialogY     = safeZoneY + safeZoneH - (_nameBarH + _dialogueH + (_padding * 3)) - (safeZoneH * 0.02);

// Recalculate dialog height correctly
private _dialogH = _nameBarH + _dialogueH + (_padding * 3);
private _portraitCtrl = objNull; // initialize to avoid "variable does not exist" error in cleanup
private _faceCtrl = objNull;     // initialize to avoid "variable does not exist" error in cleanup
private _cam = objNull;         // initialize to avoid "variable does not exist" error in cleanup

private _bgColor = [
profilenamespace getVariable ['GUI_BCG_RGB_R', 0.05],
profilenamespace getVariable ['GUI_BCG_RGB_G', 0.05],
profilenamespace getVariable ['GUI_BCG_RGB_B', 0.07],
profilenamespace getVariable ['GUI_BCG_RGB_A', 0.88]
];

// -------------------------------------------------------
// Open base display (non-modal) and obtain its reference
// Use createDisplay instead of createDialog to avoid pausing/hiding hints
// -------------------------------------------------------
(["[SAS_Conv_fnc_message] Opening overlay - Speaker: '" + _speaker + "' | Face unit: " + (if (isNull _unit) then { "none" } else { str _unit }) + " | Portrait: '" + _portrait + "'"]) call SAS_fnc_logDebug;

private _display = findDisplay 46;

if (isNull _display) exitWith {
    ["[SAS_Conv_fnc_message] ERROR: Failed to open SAS_RscGuiMessage display"] call SAS_fnc_logDebug;
    displayNull
};

// -------------------------------------------------------
// Background panel
// -------------------------------------------------------
private _bg = _display ctrlCreate ["RscText", 9100];
_bg ctrlSetPosition [_dialogX, _dialogY, _dialogW, _dialogH];
_bg ctrlSetBackgroundColor [0.05, 0.05, 0.07, 0.88];
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
    private _rttName = "sas_conv_rtt_" + str (floor (diag_tickTime * 1000));

    private _headPos = _unit modelToWorldVisual (_unit selectionPosition "head");
    _headPos set [2, _headPos select 2 + 0.5]; // shift target up to face centre
    private _localOffset = [0, 0.3, 0.09];
    private _camPos = _headPos vectorAdd (_unit vectorModelToWorld _localOffset);

    _cam = "camera" camCreate _camPos;
    _cam camSetTarget _unit;
    _cam camSetRelPos [0, 0.5, 1.5];
    _cam cameraEffect ["internal", "back", _rttName];

    _cam camCommit 1;
    _rttName setPiPEffect [0];

    _faceCtrl = _display ctrlCreate ["RscPicture", 9102];
    _faceCtrl ctrlSetPosition [_dialogX + _padding, _contentY, _portraitW, _portraitH];
    _faceCtrl ctrlSetText format ["#(argb,512,512,1)r2t(%1,1.0)", _rttName];
    _faceCtrl ctrlCommit 0;

    _textOffsetX = _portraitW + (_padding * 2);

} else {
    if (_portrait != "") then {
        _portraitCtrl = _display ctrlCreate ["RscPicture", 9102];
        _portraitCtrl ctrlSetPosition [_dialogX + _padding, _contentY, _portraitW, _portraitH];
        _portraitCtrl ctrlSetText _portrait;
        _portraitCtrl ctrlCommit 0;
        _textOffsetX = _portraitW + (_padding * 2);
        ["[SAS_Conv_fnc_message] Static portrait loaded: " + _portrait] call SAS_fnc_logDebug;
    };
};

// -------------------------------------------------------
// Dialogue text (right of portrait, or full width)
// -------------------------------------------------------
private _textX = _dialogX + _textOffsetX;
private _textW = _dialogW - _textOffsetX - _padding;
private _innerPad = 0.008;

private _textCtrl = _display ctrlCreate ["RscStructuredText", 9103];
_textCtrl ctrlSetPosition [_textX + _innerPad, _contentY + _innerPad, _textW - (_innerPad * 2), _dialogueH - (_innerPad * 2)];
_textCtrl ctrlSetBackgroundColor [0.0, 0.0, 0.0, 0.0];
_textCtrl ctrlSetStructuredText parseText _dialogue;
_textCtrl ctrlSetTextColor [0.92, 0.92, 0.92, 1.0];
_textCtrl ctrlCommit 0;

// -------------------------------------------------------
// Auto-close after duration (non-blocking). Let Unload handler clean camera.
// -------------------------------------------------------
[_duration, _nameBar, _bg, _textCtrl, _faceCtrl, _portraitCtrl, _faceCtrl, _cam] spawn {
    params ["_dur", "_nameBar", "_bg", "_textCtrl", "_faceCtrl", "_portraitCtrl", "_faceCtrl", "_cam"];
    sleep _dur;

	ctrlDelete _nameBar;
	ctrlDelete _bg;
    ctrlDelete _textCtrl;

	if (!isNull _faceCtrl) then { ctrlDelete _faceCtrl };
	if (!isNull _portraitCtrl) then { ctrlDelete _portraitCtrl };
	if (!isNull _cam) then {
            _cam cameraEffect ["terminate", "back"];
            camDestroy _cam;
    };
};

// Return display reference
_display
