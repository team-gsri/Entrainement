/*
 * Author: www.gsri.team
 * Will add required CBA settings to make the AT stand configurable.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * None, autostarted in postInit phase, see CfgFunctions
 *
 * Public: No
 */

if(hasInterface) then {
	{
		[
			format["GSRI_CCOM_AT_%1_objectType", _x#0],
			"LIST",
			format["Target type for %1", toLower (_x#1)],
			["CCOM AT", _x#1],
			[
				["Land_VR_Target_MRAP_01_F", "Land_VR_Target_APC_Wheeled_01_F", "Land_VR_Target_MBT_01_cannon_F"],
				["MRAP", "VBCI", "MBT"],
				1
			],
			1
		] call CBA_fnc_addSetting;
		[
			format["GSRI_CCOM_AT_%1_objectDistance", _x#0],
			"SLIDER",
			format["Target distance for %1", toLower (_x#1)],
			["CCOM AT", _x#1],
			[75,1000,200,0,false],
			1
		] call CBA_fnc_addSetting;

		// Initial refresh for spawning
		[format["GSRI_CCOM_AT_%1_objectType", _x#0]] call GSRI_fnc_CCOM_updateLaneAT;
	} forEach [["lane1","Left lane"], ["lane2","Center lane"], ["lane3","Right lane"]];
};

if(isServer) then {
	["CBA_SettingChanged", {
		if!("GSRI_CCOM_AT_" in _this#0) exitWith {};
		_this call GSRI_fnc_CCOM_updateLaneAT;
	}] call CBA_fnc_addEventHandler;
};
