//-->SAS Functions
class SAS {
    class Common {
        file = "sas\common\misc\functions";
        class resetGroup {};
        class fireFlare {};
        class doHalo {};
        class switchSide {};
        class isNightTime {};
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
        class loadingScreen {};
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

class SAS_Briefing {
    class Briefing {
        file = "sas\briefing\functions";
        class createDiarySubject {};
        class createBriefing {};
        class createNotes {};
        class createIntel {};
        class addDiaryRecord {};
        class createTask {};
        class createTasks {};
        class setTaskState {};
        class completeTask {};
        class failTask {};
        class cancelTask {};
    };
};
