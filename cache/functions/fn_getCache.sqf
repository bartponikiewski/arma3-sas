/*
    Description:
    Returns cached group template by name.

    Usage:
    ["templateName"] call SAS_Cache_fnc_getCache;

    Parameter(s):
    0: STRING - Template name

    Returns:
    HASHMAP or nil - The cached template data, or nil if not found
*/

params [["_name", "", [""]]];

if (_name isEqualTo "") exitWith {
    ["[getCache] Empty template name"] call SAS_fnc_logDebug;
    nil
};

private _template = missionNamespace getVariable [format ["SAS_Cache_%1", _name], nil];

if (isNil "_template") exitWith {
    [format ["[getCache] Template '%1' not found", _name]] call SAS_fnc_logDebug;
    nil
};

[format ["[getCache] Retrieved template '%1'", _name]] call SAS_fnc_logDebug;

_template
