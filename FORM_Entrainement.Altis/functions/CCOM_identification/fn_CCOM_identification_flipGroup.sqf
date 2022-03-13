/*
 * Author: www.gsri.team
 * Will (de)hide a group in identification module.
 *
 * Arguments:
 * _envId, _classId, _groupId are the group path through the vehicle tree. See configFile >> CCOM_Identification for identifiers.
 * _forceHideMode is a boolean, true will hide all, false will show all, regardless of the current state of the desired group.
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
	["_classId", ""],
	["_groupId", ""],
	["_forceHideMode", nil]
];

private _CCOM_env = missionNamespace getVariable "CCOM_Identification";

private _objects = _CCOM_env get _envId get _classId get _groupId;
private _isToHide = !isObjectHidden(_objects # 0);
if(!isNil "_forceHideMode") then {_isToHide = _forceHideMode};
{
	_x hideObjectGlobal _isToHide;
} forEach _objects;