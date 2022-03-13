/*
 * Author: www.gsri.team
 * Will check the current state of a group.
 *
 * Arguments:
 * _envId, _classId, _groupId are the path through the vehicle tree. See configFile >> CCOM_Identification for identifiers.
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
	["_groupId", ""]
];

private _CCOM_env = missionNamespace getVariable "CCOM_Identification";

private _objects = _CCOM_env get _envId get _classId get _groupId;

isObjectHidden(_objects#0);