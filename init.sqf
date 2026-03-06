
// SAS global debug flag
SAS_Debug_global = true; // Set to false to disable all SAS debug output


my_fnc_guiMessageExtended_fixed = {
	params [
		"_textMessage",                 // STRING or structured text
		["_textHeader", ""],              // STRING header (optional)
		["_buttonArray", ["OK","Cancel"]],// ARRAY of button texts
		["_isPause", true]                // BOOL to pause simulation
	];

	private _displayClass = if (_isPause) then {"RscDisplayCommonMessagePause"} else {"RscDisplayCommonMessage"};
	private _display = _displayClass createDisplay 46; // Mission display

	// Base controls from BIS_fnc_guiMessage
	private _ctrlRscMessageBox = _display displayCtrl 2351;
	private _ctrlBcgCommon = _display displayCtrl 235101;
	private _ctrlText = _display displayCtrl 235102;
	private _ctrlHeader = _display displayCtrl 235100;

	// Apply text and header
	_ctrlText ctrlSetStructuredText _textMessage;
	_ctrlHeader ctrlSetText _textHeader;

	// --- Button setup ---
	private _buttons = [];
	private _nButtons = count _buttonArray;

	// Relative positions
	private _xStart = 0.1;
	private _yBottom = 0.75;
	private _buttonSpacing = 0.01;
	private _buttonWidth = (0.8 - (_nButtons-1)*_buttonSpacing)/_nButtons;
	private _buttonHeight = 0.05;

	for "_i" from 0 to (_nButtons-1) do {
		private _btn = _display ctrlCreate ["RscButton", 2400 + _i];
		_btn ctrlSetPosition [_xStart + _i * (_buttonWidth + _buttonSpacing), _yBottom, _buttonWidth, _buttonHeight];
		_btn ctrlSetText (_buttonArray select _i);
		_btn ctrlCommit 0;
		_buttons pushBack _btn;
	};

	// --- Click handlers using closeDisplay exitCode ---
	{
		private _index = _forEachIndex;
		_x ctrlAddEventHandler ["ButtonClick", {
			(_this select 0) closeDisplay _index; // proper way
			true
		}];
	} forEach _buttons;

	// --- Escape key closes dialog with -1 ---
	_display displayAddEventHandler ["KeyDown", {
		params ["_display", "_key", "_shift"];
		if (_key == 1) then { // ESC key
			_display closeDisplay -1;
			true
		} else { false };
	}];

	// --- Wait until display closes ---
	waitUntil {isNull findDisplay _display};

	// --- Return exitCode ---
	private _exitCode = _display getVariable ["__exitCode__", -1]; // fallback -1
	_exitCode;
};

SAS_fnc_showDialogueNode = {
	private _result = ["Do you want to continue?", "Choose wisely", ["Yes","No","Maybe","Later"], true] call my_fnc_guiMessageExtended_fixed;

	if (_result >= 0) then {
		systemChat format ["You clicked: %1", ["Yes","No","Maybe","Later"] select _result];
	} else {
		systemChat "Dialog closed without selection.";
	};

}