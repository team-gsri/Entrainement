/*
 * Author: www.gsri.team
 * Will add typical obstacles on the course based on the starting object.
 *
 * Arguments:
 * _source, the course's starting object, most likely the castle tower object (Land_Castle_01_tower_F), from which the played has to rappel down.
 *
 * Return Value:
 * None
 *
 * Example:
 * None
 *
 * Public: No
 */

params[["_source", objNull]];
if(isNull _source) exitWith { ["Tried to init an obstacle course with an empty source, aborting."] call BIS_fnc_error };

// The server has to spawn obstacle objects
if(isServer) then {
	{
		private _obstacle = _x#0 createVehicle [0,0,0];
		_obstacle enableSimulationGlobal false;
		_obstacle allowDamage false;
		_obstacle setPosATL (_source getRelPos [_x#1, 90]);
		_obstacle setDir (getDir _source + (_x#2));
	} forEach [
		["Land_Obstacle_RunAround_F", 19.5, -90],
		["Land_Obstacle_Saddle_F", 31, -90],
		["Land_Obstacle_Crawl_F", 44.5, 90],
		["Land_ConcreteWall_03_m_6m_F", 52.3, 90],
		["Land_Obstacle_Climb_F", 61.5, 180],
		["GTS_Girafe", 76, -90],
		["Land_Obstacle_Cross_F", 85.4, -90]
	];
};