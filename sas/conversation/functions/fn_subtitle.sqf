/*
    Description:
    Displays cinematic subtitles using BIS_fnc_EXP_camp_playSubtitles
    with optional voice audio playback. Supports two modes:

    1) Single audio track over the whole sequence — pass the sound and
       optional source as top-level parameters.
    2) Per-entry audio — include a sound class name in each subtitle entry.

    Both modes can be combined (one global track + per-entry sounds).
    Must be called via `spawn` (contains sleep).

    Usage:
    [sequence, sound, source] spawn SAS_Conv_fnc_subtitle;

    Parameter(s):
    0: ARRAY  - Array of subtitle entries. Each entry:
                [speaker, text, timing]
                OR with per-entry audio:
                [speaker, text, timing, sound, source]
                - speaker (STRING)  : Name shown in the subtitle
                - text    (STRING)  : Subtitle text to display
                - timing  (NUMBER)  : Seconds from start when this entry appears
                - sound   (STRING)  : (Optional) CfgSounds class name for this
                                      entry ("" for no per-entry audio)
                - source  (OBJECT)  : (Optional) Unit for say3D on this entry
                                      (default: objNull = playSound)
    1: STRING - (Optional) CfgSounds class name for a single audio track
                that plays at the start over the entire sequence ("" = none)
    2: OBJECT - (Optional) Unit for say3D for the global track,
                objNull for playSound (default: objNull)

    Returns:
    Nothing

    Examples:
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

    // Text-only (no audio at all)
    [
        [
            ["Command", "All callsigns, report status.", 0]
        ]
    ] spawn SAS_Conv_fnc_subtitle;
*/

params [
    ["_sequence",    [], [[]]],
    ["_globalSound", "", [""]],
    ["_globalSource", objNull, [objNull]]
];

if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};
if (_sequence isEqualTo []) exitWith {};

(["[SAS_Conv_fnc_subtitle] Playing subtitle sequence with " + str (count _sequence) + " entries"]) call SAS_fnc_logDebug;

// Build BIS-compatible subtitle array: [speaker, text, timing]
private _bisSubtitles = [];
{
    _x params [
        ["_speaker", "", [""]],
        ["_text",    "", [""]],
        ["_timing",  0,  [0]]
    ];
    _bisSubtitles pushBack [_speaker, _text, _timing];
} forEach _sequence;

[_sequence, _globalSound, _globalSource] spawn {
    params ["_sequence", "_globalSound", "_globalSource"];
    // Play global audio track at the start (if provided)
    if (_globalSound != "") then {
        if (!isNull _globalSource) then {
            _globalSource say3D _globalSound;
            (["[SAS_Conv_fnc_subtitle] Playing global 3D sound '" + _globalSound + "' from " + str _globalSource]) call SAS_fnc_logDebug;
        } else {
            playSound _globalSound;
            (["[SAS_Conv_fnc_subtitle] Playing global 2D sound '" + _globalSound + "'"]) call SAS_fnc_logDebug;
        };
    };

    // Schedule per-entry audio playback (if any entry has a sound)
    {
        if (count _x > 3) then {
            private _sound  = _x param [3, "", [""]];
            private _timing = _x param [2, 0,  [0]];
            private _source = _x param [4, objNull, [objNull]];
            private _speaker = _x param [0, "", [""]];

            if (_sound != "") then {
                [_sound, _timing, _source, _speaker] spawn {
                    params ["_sound", "_timing", "_source", "_speaker"];

                    if (_timing > 0) then { sleep _timing; };

                    if (!isNull _source) then {
                        _source say3D _sound;
                        (["[SAS_Conv_fnc_subtitle] Playing 3D sound '" + _sound + "' from " + str _source + " for " + _speaker]) call SAS_fnc_logDebug;
                    } else {
                        playSound _sound;
                        (["[SAS_Conv_fnc_subtitle] Playing 2D sound '" + _sound + "' for " + _speaker]) call SAS_fnc_logDebug;
                    };
                };
            };
        };
    } forEach _sequence;
};
// Spawn the BIS subtitle display
_bisSubtitles call BIS_fnc_EXP_camp_playSubtitles;
sleep 1; // Short delay

