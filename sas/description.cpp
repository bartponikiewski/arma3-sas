//-->SAS Functions
#ifdef sas_cfg_functions

class SAS {
    class Common {
        file = "sas\common\misc\functions";
        class resetGroup {};
        class fireFlare {};
    };

    class Logging {
        file = "sas\common\logging\functions";
        class logDebug {};
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
#endif
//<--SAS Functions


