/*
 * Author: www.gsri.team
 * Will update AT stand lanes with configured parameters.
 *
 * Arguments:
 * CBA Setting event handler standards.
 *
 * Return Value:
 * None
 *
 * Example:
 * None
 *
 * Public: No
 */

params ["_setting", "_value"];

// Recover the lane identifier :
private _lane = _setting select [13, 5];
private _origin = missionNamespace getVariable ["GSRI_CCOM_AT_origin", objNull];
if(isNull _origin) exitWith {["Trying to update a lane, but origin not found, aborting."] call BIS_fnc_error};

// Recover the currently used object ; if non-existent, objNull is perfectly fine.
private _target = missionNamespace getVariable [format["GSRI_CCOM_AT_%1_object",_lane], objNull];

// Handle any change in target type
private _expectedType = call compile format["GSRI_CCOM_AT_%1_objectType", _lane];
if(typeOf _target != _expectedType) then {
	deleteVehicle _target;
	_target = createVehicle[_expectedType, [0,0,0]];
    [_target,1] call BIS_fnc_VRHitpart;
	missionNamespace setVariable [format["GSRI_CCOM_AT_%1_object", _lane], _target, true];
};

// Handle any change in the target distance
private _expectedDistance = call compile format["GSRI_CCOM_AT_%1_objectDistance", _lane];
private _centeredPos = (_origin getRelPos [_expectedDistance, 180]);

private _newPos = switch (_lane) do {
	case "lane1": { _centeredPos getPos [10, 180 + getDir _origin - 90] };
	case "lane3": { _centeredPos getPos [10, 180 + getDir _origin + 90] };
	default { _centeredPos };
};

_target setPosATL _newPos;
