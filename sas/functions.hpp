//-->SAS Functions
class SAS {
    class Common {
        file = "sas\common\misc\functions";
        class resetGroup {};
        class fireFlare {};
        class doHalo {};
        class switchSide {};
        class isNightTime {};
        class createMarker {};
        class addWaypoint {};
        class guideAmmo {};
    };

    class Logging {
        file = "sas\common\logging\functions";
        class logDebug {};
    };

    class Gui {
        file = "sas\common\gui\functions";
        class guiMessage {};
        class blackIn {};
        class blackOut {};
    };
};

class SAS_Init {
    class Init {
        file = "sas\init\functions";
        class loadingScreen { postInit = 1; };
        class finish {};
        class setLoadingState {};
        class getLoadingState {};
    };
};

class SAS_Skills {
    class Skills {
        file = "sas\skills\functions";
        class set {};
        class paramSkills {};
    };
};

class SAS_Intro {
    class Intro {
        file = "sas\intro\functions";
        class quote {};
        class uav {};
        class infoText {};
        class opening {};
        class enabled {};
        class play {};
    };
};

class SAS_Conv {
    class Conversation {
        file = "sas\conversation\functions";
        class messageDialog {};
        class message {};
        class subtitle {};
    };
};

class SAS_Reinforcement {
    class Reinforcement {
        file = "sas\reinforcement\functions";
        class registerGroup {};
        class onGroupFearChanged {};
        class requestReinforcements {};
        class sendReinforcements {};
        class getCanCall {};
        class setCanCall {};
        class getCanBeCalled {};
        class setCanBeCalled {};
        class registerReinforcementGroup {};
        class getRegisteredReinforcementGroups {};
        class findNearestReinforcementGroup {};
        class registerCallerGroup {};
    };
};

class SAS_Morale {
    class Morale {
        file = "sas\morale\functions";
        class registerGroup {};
        class calculateGroupFear {};
        class getGroupFear {};
        class onUnitKilled {};
    };
};

class SAS_Task {
    class Task {
        file = "sas\task\functions";
        class patrol {};
        class defend {};
        class garrison {};
        class garrisonUnits {};
    };
};

class SAS_NightOps {
    class NightOps {
        file = "sas\nightops\functions";
        class useFlashlights {};
        class useFlares {};
        class fireFlaresAtTargetRecurring {};
        class switchLight {};
        class switchLightsInArea {};
        class setAsLightsPowerSource {};
        class addPowerSourceAction {};
        class removePowerSourceAction {};
    };
};

class SAS_Civilians {
    class Civilians {
        file = "sas\civilians\functions";
        class makeHostile {};
        class createHostileZone {};
        class makeHostileInArea {};
    };
};

class SAS_Hostage {
    class Hostage {
        file = "sas\hostage\functions";
        class make {};
        class setHostageState {};
        class addFreeHostageAction {};
        class removeFreeHostageAction {};
    };
};

class SAS_Gunship {
    class Gunship {
        file = "sas\gunship\functions";
        class init {};
        class callOnPosition {};
        class createGunship {};
        class addCallMenu {};
        class removeCallMenu {};
        class addCommandMenu {};
        class removeCommandMenu {};
        class setGunshipMode {};
        class getGunshipMode {};
        class setGunshipAmmo {};
        class getGunshipAmmo {};
        class setGunshipUnit {};
        class getGunshipUnit {};
        class setGunshipUnitWeapon {};
        class getGunshipUnitWeapon {};
        class setMaxCalls {};
        class getMaxCalls {};
        class setJtacUnit {};
        class getJtacUnit {};
        class generateSubmenus {};
        class startMission {};
        class message {};
        class remoteControlWeapon {};
        class doFire {};
        class rtb {};
        class trackLaserTarget {};
        class setGunshipState {};
        class getGunshipState {};
        class setJtacUnits {};
        class getJtacUnits {};

    };
};

class SAS_Briefing {
    class Briefing {
        file = "sas\briefing\functions";
        class createDiarySubject {};
        class createBriefing {};
        class createNotes {};
        class addDiaryRecord {};
        class createTask {};
        class createTasks {};
        class setTaskState {};
        class completeTask {};
        class failTask {};
        class cancelTask {};
    };
};

class SAS_Intel {
    class Intel {
        file = "sas\intel\functions";
        class setIntel {};
        class setIntelSimple {};
        class setIntelAction {};
        class intelDialog {};
    };
};

class SAS_Fastrope {
    class Fastrope {
        file = "sas\fastrope\functions";
        class createRopes {};
        class cutRopes {};
        class doFastrope {};
        class dropCrew {};
        class getHeliConfig {};
        class isHeliReady {};
        class startMission {};
    };
};

class SAS_DragBody {
    class DragBody {
        file = "sas\dragbody\functions";
        class init { postInit = 1; };
        class addDragAction {};
        class drag {};
        class release {};
    };
};

class SAS_Captive {
    class Captive {
        file = "sas\captive\functions";
        class register {};
        class surrender {};
        class setCaptiveState {};
        class addSurrenderAction {};
        class removeSurrenderAction {};
        class addArrestAction {};
        class removeArrestAction {};
        class addEscortAction {};
        class removeEscortAction {};
        class escort {};
        class stopEscort {};
        class loadInVehicle {};
        class unloadFromVehicle {};
        class removeUnloadAction {};
    };
};

class SAS_Cache {
    class Cache {
        file = "sas\cache\functions";
        class getCache {};
        class cacheGroup {};
        class spawnGroup {};
        class spawnUnits {};
    };
};
