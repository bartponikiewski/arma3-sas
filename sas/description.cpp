//-->SAS Functions
#ifdef sas_cfg_functions
class SAS {
    class Logging {
        file = "sas\logging\functions";
        class logDebug {};
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
#endif
//<--SAS Functions
