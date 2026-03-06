//-->SAS Functions
#ifdef sas_cfg_functions

class SAS {
    class Common {
        file = "sas\common\misc\functions";
        class resetGroup {};
        class fireFlare {};
        class doHalo {};
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

#endif
//<--SAS Functions






