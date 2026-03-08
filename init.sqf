
// SAS global debug flag
SAS_Debug_global = true; // Set to false to disable all SAS debug output


SAS_test = {
private _timeline =
[
	[0.0, { hint "Start of the Timeline" }],
	[1.0, { hint "Event 1" }],
	[3.0, { hint "End of the timeline" }]
];

[_timeline, 0, "", { hint "Interrupted" }, { hint "Timeline done" }] spawn BIS_fnc_eventTimeline;
}