
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

// -------------------------------------------------------
// SAS Phone: Base empty dialog for cellphone UI
// -------------------------------------------------------
class SAS_RscPhoneDialog
{
    idd = 9002;
    movingEnable = 0;
    enableSimulation = 0;
    onLoad = "";
    class Controls {};
};

// Fully invisible clickable button - no visual in any state
class SAS_RscInvisibleButton
{
    idc = -1;
    type = 1;           // CT_BUTTON
    style = 0;
    x = 0; y = 0; w = 0; h = 0;
    text = "";
    font = "RobotoCondensed";
    sizeEx = 0.04;
    colorText[]               = {0, 0, 0, 0};
    colorBackground[]         = {0, 0, 0, 0.01};
    colorBackgroundActive[]   = {0, 0, 0, 0.01};
    colorBackgroundDisabled[] = {0, 0, 0, 0};
    colorDisabled[]           = {0, 0, 0, 0};
    colorFocused[]            = {0, 0, 0, 0.01};
    colorShadow[]             = {0, 0, 0, 0};
    colorBorder[]             = {0, 0, 0, 0};
    borderSize = 0;
    offsetX = 0;
    offsetY = 0;
    offsetPressedX = 0;
    offsetPressedY = 0;
    soundEnter[] = {"", 0, 1};
    soundPush[]  = {"", 0, 1};
    soundClick[] = {"", 0, 1};
    soundEscape[] = {"", 0, 1};
};


