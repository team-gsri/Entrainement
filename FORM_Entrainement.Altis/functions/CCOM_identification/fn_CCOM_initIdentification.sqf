/*
 * Author: www.gsri.team
 * Will initialize the identification module by adding relevant actions on the control remote.
 *
 * Arguments:
 * _ctrl, the object on which the actions are being added.
 *
 * Return Value:
 * None
 *
 * Example:
 * None
 *
 * Public: No
 */

params[["_ctrl", objNull]];
if(isNull _ctrl) exitWith {};

// The server would not have this variable existing, so it needs to create a hashmap and populate it.
// On client exec, this variable is created and populated with incomplete data, but this doesn't matter since it cease to exist at the end of the script. Only the ids are needed for ACE actions.
private _CCOM_env = missionNamespace getVariable ["CCOM_Identification", createHashMap];

private _allEnvironnment = (missionConfigFile >> "CCOM_Identification") call BIS_fnc_getCfgSubClasses;
{
	// Add environnement main action (air, land)
	private _envAction = [
		format["%1_action",_x],
		getText (missionConfigFile >> "CCOM_Identification" >> _x >> "displayName"),
		"",
		{ _this#2 remoteExecCall ["GSRI_fnc_CCOM_identification_flipPath", 2] },
		{true},
		{},
		[_x]] call ace_interact_menu_fnc_createAction;
	[_ctrl, 0, ["ACE_MainActions"], _envAction] call ace_interact_menu_fnc_addActionToObject;
	_CCOM_env set [_x, createHashMap];

	// Add vehicle class main action (armored, fixed wings, etc)
	private _envId = _x;
	private _allVehicleClasses = (missionConfigFile >> "CCOM_Identification" >> _envId) call BIS_fnc_getCfgSubClasses;
	{
		private _classAction = [
			format["%1_action",_x],
			getText (missionConfigFile >> "CCOM_Identification" >> _envId >> _x >> "displayName"),
			"",
			{ _this#2 remoteExecCall ["GSRI_fnc_CCOM_identification_flipPath", 2] },
			{true},
			{},
			[_envId, _x]] call ace_interact_menu_fnc_createAction;
		[_ctrl, 0, ["ACE_MainActions", format["%1_action",_envId]], _classAction] call ace_interact_menu_fnc_addActionToObject;
		(_CCOM_env get _envId) set [_x, createHashMap];

		private _classId = _x;
		private _allVehicleGroups = (missionConfigFile >> "CCOM_Identification" >> _envId >> _classId) call BIS_fnc_getCfgSubClasses;
		{
			private _groupAction = [
				format["%1_action",_x],
				getText (missionConfigFile >> "CCOM_Identification" >> _envId >> _classId >> _x >> "displayName"),
				"",
				{ _this#2 remoteExecCall ["GSRI_fnc_CCOM_identification_flipPath", 2] },
				{true},
				{},
				[_envId, _classId, _x]] call ace_interact_menu_fnc_createAction;
			[_ctrl, 0, ["ACE_MainActions", format["%1_action",_envId], format["%1_action",_classId]], _groupAction] call ace_interact_menu_fnc_addActionToObject;

			private _groupId = _x;
			private _groupData = getArray (missionConfigFile >> "CCOM_Identification" >> _envId >> _classId >> _groupId >> "vehicleData");
			if(isServer) then {
				private _groupObjects = [];
				{
					private _object = createVehicle [_x#0, _x#1];
					_object allowDamage false;
					_object hideObjectGlobal true;
					_groupObjects pushBack _object;
				} forEach _groupData;
				((_CCOM_env get _envId) get _classId) set [_x, _groupObjects];
			};
		} forEach _allVehicleGroups;
	} forEach _allVehicleClasses;
} forEach _allEnvironnment;

// Once the hashmap is populated, server must broadcast it to let clients read from it.
if(isServer) then { missionNamespace setVariable ["CCOM_Identification", _CCOM_env, true] };
