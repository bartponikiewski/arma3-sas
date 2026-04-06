/*
    Description:
    Displays a Nokia 3310 cellphone overlay with SMS messages the player
    can scroll through. Uses the phone_3310_s.paa background image.
    Messages are rendered on the green LCD screen area.

    Navigation uses the actual Nokia 3310 buttons:
    - C button (left)      = Close phone
    - D-pad up/down        = Previous/Next message
    Also supports: arrow keys, mouse wheel, ESC to close.

    Uses dialog class "SAS_RscPhoneDialog" (idd 9002) from rsc.hpp.

    Usage:
    [messages, onClose] call SAS_Phone_fnc_openPhone;

    Parameter(s):
    0: ARRAY  - _messages: Array of SMS entries. Each entry:
                [sender, time, text, onDisplay]
                  sender    : STRING - Contact name
                  time      : STRING - Timestamp
                  text      : STRING - Message body
                  onDisplay : (Optional) CODE - Executed once when this message
                              is first displayed. Receives [sender, time, text, index].
    1: (Optional) CODE    - _onClose: Code executed when phone closes (default: {})
    2: (Optional) BOOLEAN - _logDiary: If true, logs all messages to diary
                            under "Intel Log" subject (default: true)

    Returns:
    DISPLAY - Reference to the created display, or displayNull on failure

    Examples:
    // Basic messages (no callbacks)
    [
        [
            ["Informant", "21:37", "Meet me at the church. Come alone."],
            ["Informant", "21:42", "Bring the money. No weapons."],
            ["Command",   "22:01", "We have eyes on the church. Proceed."]
        ]
    ] call SAS_Phone_fnc_openPhone;

    // With per-message callbacks (fired once when first displayed)
    [
        [
            ["Informant", "21:37", "Meet me at the church.", {
                params ["_sender", "_time", "_text", "_index"];
                hint "First message displayed!";
            }],
            ["Command", "22:01", "Proceed.", {
                ["obj_1", "SUCCEEDED"] call SAS_Briefing_fnc_setTaskState;
            }]
        ]
    ] call SAS_Phone_fnc_openPhone;
*/

params [
    ["_messages",  [],    [[]]],
    ["_onClose",   {},    [{}]],
    ["_logDiary",  true,  [true]]
];

if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};
if (count _messages == 0) exitWith {
    ["[SAS_Phone_fnc_openPhone] No messages provided"] call SAS_fnc_logDebug;
    displayNull
};

// -------------------------------------------------------
// Phone dimensions
// Image is 1024x1024. SafeZone units need aspect ratio
// correction so the square image renders as a square.
// -------------------------------------------------------
private _res = getResolution;
private _pixelRatio = (_res select 0) / (_res select 1);
private _szRatio = safeZoneW / safeZoneH;
private _phoneH = 0.92;
private _phoneW = _phoneH * (_szRatio / _pixelRatio);
private _phoneX = safeZoneX + (safeZoneW - _phoneW) * 0.5;
private _phoneY = safeZoneY + (safeZoneH - _phoneH) * 0.5;

// -------------------------------------------------------
// LCD screen area (fractions of the 1024x1024 image)
//   Measured from phone_3310_s.png:
//   left ~265px  top ~195px  right ~745px  bottom ~435px
// -------------------------------------------------------
private _scrRelX = 0.35;
private _scrRelY = 0.265;
private _scrRelW = 0.3;
private _scrRelH = 0.215;

private _screenX = _phoneX + _scrRelX * _phoneW;
private _screenY = _phoneY + _scrRelY * _phoneH;
private _screenW = _scrRelW * _phoneW;
private _screenH = _scrRelH * _phoneH;

private _pad = 0.005;

// Nokia LCD green color
private _lcdColor = [0.58, 0.65, 0.35, 1.0];
// Dark pixel colors (Nokia LCD style)
private _pixelColor = "#1A2008";
private _pixelColorDim = "#3A4828";

// -------------------------------------------------------
// Button hit areas (fractions of 1024x1024 image)
//
// C button (left, below screen): close phone
//   ~220px,510px  size 105x50
//
// D-pad up (top half of d-pad): prev message
//   ~420px,470px  size 140x40
//
// D-pad down (bottom half of d-pad): next message
//   ~420px,530px  size 140x40
// -------------------------------------------------------
private _cBtnRelX = 0.35;  private _cBtnRelY = 0.55;
private _cBtnRelW = 0.09;  private _cBtnRelH = 0.06;

private _dpadUpRelX = 0.56;  private _dpadUpRelY = 0.54;
private _dpadUpRelW = 0.09;  private _dpadUpRelH = 0.05;

private _dpadDnRelX = 0.52;  private _dpadDnRelY = 0.59;
private _dpadDnRelW = 0.09;  private _dpadDnRelH = 0.05;

// -------------------------------------------------------
// Open dialog
// -------------------------------------------------------
createDialog "SAS_RscPhoneDialog";
private _display = findDisplay 9002;

if (isNull _display) exitWith {
    ["[SAS_Phone_fnc_openPhone] ERROR: Failed to open SAS_RscPhoneDialog"] call SAS_fnc_logDebug;
    displayNull
};

_display setVariable ["SAS_Phone_messages", _messages];
_display setVariable ["SAS_Phone_index", 0];
_display setVariable ["SAS_Phone_onClose", _onClose];
_display setVariable ["SAS_Phone_pixelColor", _pixelColor];
_display setVariable ["SAS_Phone_pixelColorDim", _pixelColorDim];
_display setVariable ["SAS_Phone_firedCallbacks", []];
_display setVariable ["SAS_Phone_logDiary", _logDiary];

// DEBUG: set to true to color buttons for positioning
private _debug = false;

// -------------------------------------------------------
// Phone background image
// -------------------------------------------------------
private _bgImg = _display ctrlCreate ["RscPicture", 9300];
_bgImg ctrlSetPosition [_phoneX, _phoneY, _phoneW, _phoneH];
_bgImg ctrlSetText "sas\assets\images\phone_3310_s.paa";
_bgImg ctrlCommit 0;

// -------------------------------------------------------
// LCD screen background (Nokia green)
// -------------------------------------------------------
private _screen = _display ctrlCreate ["RscText", 9310];
_screen ctrlSetPosition [_screenX, _screenY, _screenW, _screenH];
if (_debug) then {
    _screen ctrlSetBackgroundColor [1, 0, 0, 0.5];  // semi-transparent red for debugging
};
_screen ctrlCommit 0;

// -------------------------------------------------------
// LCD sub-areas
// -------------------------------------------------------
private _headerH    = _screenH * 0.15;
private _counterH   = _screenH * 0.13;
private _softLabelH = _screenH * 0.15;
private _msgAreaY   = _screenY + _headerH + _counterH;
private _msgAreaH   = _screenH - _headerH - _counterH - _softLabelH;
private _inset      = _pad * 1.5;

// -------------------------------------------------------
// Header - "Messages"
// -------------------------------------------------------
private _header = _display ctrlCreate ["RscStructuredText", 9311];
_header ctrlSetPosition [_screenX + _inset, _screenY, _screenW - (_inset * 2), _headerH];
_header ctrlSetBackgroundColor [0, 0, 0, 0];
_header ctrlSetShadow 0;
_header ctrlCommit 0;
_header ctrlSetStructuredText parseText format [
    "<t align='center' color='%1' size='0.55' shadow='0' font='EtelkaMonospacePro'>Messages</t>",
    _pixelColor
];

// -------------------------------------------------------
// Message counter
// -------------------------------------------------------
private _counter = _display ctrlCreate ["RscStructuredText", 9312];
_counter ctrlSetPosition [_screenX + _inset, _screenY + _headerH, _screenW - (_inset * 2), _counterH];
_counter ctrlSetBackgroundColor [0, 0, 0, 0];
_counter ctrlCommit 0;

// -------------------------------------------------------
// Message display area
// -------------------------------------------------------
private _msgCtrl = _display ctrlCreate ["RscStructuredText", 9313];
_msgCtrl ctrlSetPosition [_screenX + _inset, _msgAreaY, _screenW - (_inset * 2), _msgAreaH];
_msgCtrl ctrlSetBackgroundColor [0, 0, 0, 0];
_msgCtrl ctrlCommit 0;

// -------------------------------------------------------
// Soft-key labels at bottom of LCD
// Left: "C Close"   Right: arrow indicators
// -------------------------------------------------------
private _softY = _screenY + _screenH - _softLabelH;
private _softHalfW = (_screenW - (_inset * 2)) * 0.5;

private _softLeft = _display ctrlCreate ["RscStructuredText", 9330];
_softLeft ctrlSetPosition [_screenX + _inset, _softY, _softHalfW, _softLabelH];
_softLeft ctrlSetBackgroundColor [0, 0, 0, 0];
_softLeft ctrlSetStructuredText parseText format [
    "<t color='%1' size='0.5' shadow='0' font='EtelkaMonospacePro'>C Close</t>", _pixelColorDim
];
_softLeft ctrlCommit 0;

private _softRight = _display ctrlCreate ["RscStructuredText", 9331];
_softRight ctrlSetPosition [_screenX + _inset + _softHalfW, _softY, _softHalfW, _softLabelH];
_softRight ctrlSetBackgroundColor [0, 0, 0, 0];
_softRight ctrlCommit 0;

// -------------------------------------------------------
// Render function
// -------------------------------------------------------
private _fnc_render = {
    params ["_disp"];
    private _msgs  = _disp getVariable ["SAS_Phone_messages", []];
    private _idx   = _disp getVariable ["SAS_Phone_index", 0];
    private _total = count _msgs;
    private _dark  = _disp getVariable ["SAS_Phone_pixelColor", "#1A2008"];
    private _dim   = _disp getVariable ["SAS_Phone_pixelColorDim", "#3A4828"];

    if (_total == 0) exitWith {};

    private _msg = _msgs select _idx;
    _msg params [["_sender", ""], ["_time", ""], ["_text", ""], ["_onDisplay", {}]];

    // Fire onDisplay callback once per message
    private _fired = _disp getVariable ["SAS_Phone_firedCallbacks", []];
    if !(_idx in _fired) then {
        _fired pushBack _idx;
        _disp setVariable ["SAS_Phone_firedCallbacks", _fired];
        if !(_onDisplay isEqualTo {}) then {
            [_sender, _time, _text, _idx] call _onDisplay;
        };
    };

    // Counter with arrow indicators
    private _counterCtrl = _disp displayCtrl 9312;
    private _arrows = "";
    if (_idx > 0) then { _arrows = _arrows + "^ "; } else { _arrows = _arrows + "  "; };
    _arrows = _arrows + format ["%1/%2", _idx + 1, _total];
    if (_idx < _total - 1) then { _arrows = _arrows + " v"; } else { _arrows = _arrows + "  "; };
    _counterCtrl ctrlSetStructuredText parseText format [
        "<t align='center' color='%1' size='0.4' shadow='0' font='EtelkaMonospacePro'>%2</t>",
        _dim, _arrows
    ];

    // Message content
    private _msgDisplay = _disp displayCtrl 9313;
    if (_sender != "") then {
        _msgDisplay ctrlSetStructuredText parseText format [
            "<t color='%1' size='0.5' shadow='0' font='EtelkaMonospacePro'>From: %2  %3</t><br/><t color='%4' size='0.3' shadow='0'>---</t><br/><t color='%5' size='0.5' shadow='0' font='EtelkaMonospacePro'>%6</t>",
            _dark, _sender, _time, _dim, _dark, _text
        ];
    } else {
        _msgDisplay ctrlSetStructuredText parseText format [
            "<t color='%1' size='0.5' shadow='0' font='EtelkaMonospacePro'>%2</t>",
            _dark, _text
        ];
    };

    // Right soft-key label - show nav hints
    private _rightCtrl = _disp displayCtrl 9331;
    private _navHint = "";
    if (_idx > 0 && _idx < _total - 1) then {
        _navHint = "^v Nav";
    } else {
        if (_idx > 0) then { _navHint = "^ Prev"; };
        if (_idx < _total - 1) then { _navHint = "v Next"; };
    };
    _rightCtrl ctrlSetStructuredText parseText format [
        "<t align='right' color='%1' size='0.5' shadow='0' font='EtelkaMonospacePro'>%2</t>",
        _dim, _navHint
    ];
};

_display setVariable ["SAS_Phone_fnc_render", _fnc_render];

// -------------------------------------------------------
// Button hit areas (debug: colored RscText, no interaction)
// Clicks are handled via display MouseButtonDown event
// -------------------------------------------------------
private _cBtnArea = [_phoneX + _cBtnRelX * _phoneW, _phoneY + _cBtnRelY * _phoneH, _cBtnRelW * _phoneW, _cBtnRelH * _phoneH];
private _upBtnArea = [_phoneX + _dpadUpRelX * _phoneW, _phoneY + _dpadUpRelY * _phoneH, _dpadUpRelW * _phoneW, _dpadUpRelH * _phoneH];
private _dnBtnArea = [_phoneX + _dpadDnRelX * _phoneW, _phoneY + _dpadDnRelY * _phoneH, _dpadDnRelW * _phoneW, _dpadDnRelH * _phoneH];

_display setVariable ["SAS_Phone_cBtnArea", _cBtnArea];
_display setVariable ["SAS_Phone_upBtnArea", _upBtnArea];
_display setVariable ["SAS_Phone_dnBtnArea", _dnBtnArea];

if (_debug) then {
    {
        _x params ["_idc", "_area", "_col"];
        private _dbg = _display ctrlCreate ["RscText", _idc];
        _dbg ctrlSetPosition _area;
        _dbg ctrlSetBackgroundColor _col;
        _dbg ctrlCommit 0;
    } forEach [
        [9340, _cBtnArea,  [0, 0, 1, 0.5]],
        [9341, _upBtnArea, [0, 1, 0, 0.5]],
        [9342, _dnBtnArea, [1, 1, 0, 0.5]]
    ];
};

// -------------------------------------------------------
// Mouse click handler - check if click is inside a button area
// -------------------------------------------------------
_display displayAddEventHandler ["MouseButtonDown", {
    params ["_disp", "_button", "_mx", "_my"];
    if (_button != 0) exitWith {};  // left click only

    private _fnc_inArea = {
        params ["_mx", "_my", "_area"];
        _area params ["_ax", "_ay", "_aw", "_ah"];
        (_mx >= _ax && _mx <= _ax + _aw && _my >= _ay && _my <= _ay + _ah)
    };

    // C button = close
    if ([_mx, _my, _disp getVariable "SAS_Phone_cBtnArea"] call _fnc_inArea) exitWith {
        _disp closeDisplay 0;
    };

    // D-pad Up = prev
    if ([_mx, _my, _disp getVariable "SAS_Phone_upBtnArea"] call _fnc_inArea) exitWith {
        private _idx = _disp getVariable ["SAS_Phone_index", 0];
        if (_idx > 0) then {
            _disp setVariable ["SAS_Phone_index", _idx - 1];
            [_disp] call (_disp getVariable "SAS_Phone_fnc_render");
        };
    };

    // D-pad Down = next
    if ([_mx, _my, _disp getVariable "SAS_Phone_dnBtnArea"] call _fnc_inArea) exitWith {
        private _idx = _disp getVariable ["SAS_Phone_index", 0];
        private _max = (count (_disp getVariable ["SAS_Phone_messages", []])) - 1;
        if (_idx < _max) then {
            _disp setVariable ["SAS_Phone_index", _idx + 1];
            [_disp] call (_disp getVariable "SAS_Phone_fnc_render");
        };
    };
}];

// -------------------------------------------------------
// Keyboard & mouse wheel
// -------------------------------------------------------
_display displayAddEventHandler ["KeyDown", {
    params ["_disp", "_key"];
    private _idx  = _disp getVariable ["SAS_Phone_index", 0];
    private _max  = (count (_disp getVariable ["SAS_Phone_messages", []])) - 1;
    private _handled = false;

    if (_key == 1) then {  // ESC
        _disp closeDisplay 0;
        _handled = true;
    };
    if (_key in [200, 203]) then {  // Up / Left arrow
        if (_idx > 0) then {
            _disp setVariable ["SAS_Phone_index", _idx - 1];
            [_disp] call (_disp getVariable "SAS_Phone_fnc_render");
        };
        _handled = true;
    };
    if (_key in [208, 205]) then {  // Down / Right arrow
        if (_idx < _max) then {
            _disp setVariable ["SAS_Phone_index", _idx + 1];
            [_disp] call (_disp getVariable "SAS_Phone_fnc_render");
        };
        _handled = true;
    };
    _handled
}];

_display displayAddEventHandler ["MouseZChanged", {
    params ["_disp", "_delta"];
    private _idx  = _disp getVariable ["SAS_Phone_index", 0];
    private _max  = (count (_disp getVariable ["SAS_Phone_messages", []])) - 1;

    if (_delta > 0 && _idx > 0) then {
        _disp setVariable ["SAS_Phone_index", _idx - 1];
        [_disp] call (_disp getVariable "SAS_Phone_fnc_render");
    };
    if (_delta < 0 && _idx < _max) then {
        _disp setVariable ["SAS_Phone_index", _idx + 1];
        [_disp] call (_disp getVariable "SAS_Phone_fnc_render");
    };
}];

// -------------------------------------------------------
// On close callback
// -------------------------------------------------------
_display displayAddEventHandler ["Unload", {
    params ["_disp"];

    // Log only viewed messages to diary
    if (_disp getVariable ["SAS_Phone_logDiary", true]) then {
        private _msgs  = _disp getVariable ["SAS_Phone_messages", []];
        private _fired = _disp getVariable ["SAS_Phone_firedCallbacks", []];
        if (count _fired > 0) then {
            private _body = "";
            {
                private _idx = _x;
                private _msg = _msgs select _idx;
                _msg params [["_s", ""], ["_t", ""], ["_m", ""]];
                if (_body != "") then { _body = _body + "<br/>"; };
                if (_s != "") then {
                    _body = _body + format ["[%1] %2: %3", _t, _s, _m];
                } else {
                    _body = _body + _m;
                };
            } forEach _fired;
            ["Intel Log", "Phone Messages", _body] call SAS_Briefing_fnc_addDiaryRecord;
        };
    };

    private _cb = _disp getVariable ["SAS_Phone_onClose", {}];
    [] call _cb;
}];

// -------------------------------------------------------
// Render first message
// -------------------------------------------------------
[_display] call _fnc_render;

["[SAS_Phone_fnc_openPhone] Phone opened with " + str (count _messages) + " message(s)"] call SAS_fnc_logDebug;

_display
