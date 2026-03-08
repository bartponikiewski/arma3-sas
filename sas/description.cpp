//-->SAS Functions
#ifdef sas_cfg_functions

class SAS {
    class Common {
        file = "sas\common\misc\functions";
        class resetGroup {};
        class fireFlare {};
        class doHalo {};
        class switchSide {};
    };

    class Logging {
        file = "sas\common\logging\functions";
        class logDebug {};
    };

    class Gui {
        file = "sas\common\gui\functions";
        class guiMessage {};
    };
};

class SAS_Intro {
    class Intro {
        file = "sas\intro\functions";
        class quote {};
        class uav {};
        class infoText {};
        class opening {};
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
    };
};

class SAS_Civilians {
    class Civilians {
        file = "sas\civilians\functions";
        class makeHostile {};
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
    };
};

#endif

//<--SAS Functions






