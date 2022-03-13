/*
 * Author: www.gsri.team
 * Will check the current state of a class.
 *
 * Arguments:
 * _envId, _classId are the path through the vehicle tree. See configFile >> CCOM_Identification for identifiers.
 *
 * Return Value:
 * None
 *
 * Example:
 * None
 *
 * Public: No
 */

params[
	["_envId", ""],
	["_classId", ""]
];

private _CCOM_env = missionNamespace getVariable "CCOM_Identification";

// We have to get all associated groups, see if they are hidden, then see if the class is mainly hidden or not.
// If yes, then we want to unhide it all.
// If no, then we want to hide it all, of course.
private _groupIds = keys (_CCOM_env get _envId get _classId);
private _areHiddenGroups = _groupIds apply {[_envId, _classId, _x] call GSRI_fnc_CCOM_identification_isGroupHidden};
private _isClassHidden = ({_x isEqualTo true} count _areHiddenGroups >= count _areHiddenGroups / 2);

_isClassHidden