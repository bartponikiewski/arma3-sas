//-->SAS RSC
#ifdef sas_cfg_rsc
// -------------------------------------------------------
// SAS GUI: Base empty dialog (mouse-enabled, no controls)
// All content is created dynamically via SAS_fnc_guiMessage
// -------------------------------------------------------
class SAS_RscGuiMessage
{
    idd = 9001;
    movingEnable = 0;       // integer 0 required in config, not false
    enableSimulation = 0;   // disables player input while dialog is open
    onLoad = "";
    class Controls {};
};
#endif
//<--SAS RSC




