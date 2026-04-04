params ["_heli"];

// Config for ropes positions. Inspired by SHK
private _config = [
  //[MELB] Mission Enhanced Little Bird
  ["MELB_MH6M",[],[[1.2,0.8,-0.1],[-1.2,0.8,-0.1]]],
  
  // RHS: Armed Forces of Russian Federation
  ["RHS_Mi8_base",[],[[0,-3,0]]],
  ["RHS_Mi24_base",[],[[1.6,3.3,0],[-0.4,3.3,0]]],
  ["RHS_Ka60_grey",[],[[1.4,1.35,0],[-1.4,1.35,0]]],
  
  //RHS: United States Armed Forces
  ["RHS_CH_47F_base",[],[[0,-0.4,0]]],
  ["RHS_UH60_base",["DoorRB"],[[1.44,1.93,-0.49]]],
  ["RHS_UH1_base",["DoorLB","DoorRB"],[[0.95,3,-0.9],[-0.95,3,-0.9]]],
    
  // Arma 3
  ["Heli_Light_01_unarmed_base_F",[],[[1.1,0.5,-0.8],[-1.1,0.5,-0.8]]], //Hummingbird
  ["Heli_Transport_01_base_F",["door_L","door_R"],[[-1.01,2.5,0.25],[1.13,2.5,0.25]]], //Ghost Hawk
  ["Heli_Transport_03_base_F",["Door_rear_source"],[[-1.35,-4.6,-0.5],[1.24,-4.6,-0.5]]], //Huron  Side doors: "Door_L_source","Door_R_source"
  ["I_Heli_Transport_02_F",["CargoRamp_Open"],[[0,-5,0]]], //Mohawk
  ["Heli_light_03_base_F",[],[[0.95,3,-0.9],[-0.95,3,-0.9]]], //Hellcat
  ["Heli_Attack_02_base_F",["door_L","door_R"],[[1.3,1.3,-0.6],[-1.3,1.3,-0.6]]], //Kajman
  ["Heli_Light_02_base_F",[],[[1.35,1.35,0],[-1.45,1.35,0]]], //Orca
  ["O_Heli_Transport_04_covered_F",["Door_4_source","Door_5_source"],[[1.3,1.3,-0.1],[-1.5,1.3,-0.1]]], //Taru covered
  ["O_Heli_Transport_04_bench_F",["Door_4_source","Door_5_source"],[[1.3,0.15,-0.1],[-1.5,0.15,-0.1]]] //Taru bench underneath
    
];


// Get ropes positions for the helicopter type
private _matchedHeliConfigs = _config select { _heli isKindOf (_x select 0) };
private _heliConfig = if (count _matchedHeliConfigs > 0) then { _matchedHeliConfigs select 0 } else { [] };

private _heliRopesPositions = if (count _heliConfig > 0) then { _heliConfig select 2 } else { [[0,0,0]] };
private _heliDoors = if (count _heliConfig > 0) then { _heliConfig select 1 } else { [] };
private _existingRopes = _heli getVariable ["SAS_Fastrope_attachedRopes", []];

[_heliRopesPositions, _heliDoors, _existingRopes];