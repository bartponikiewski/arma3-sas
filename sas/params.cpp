//-->Mission parameters
#ifdef sas_cfg_params
class SAS_Intro_Enabled 
{
    title = "Intro";
    texts[] = { "ENABLED", "DISABLED" };
    values[] = { true, false };
    default = true;
}

class SAS_Skills
{
    title = "Ai Skills";
    texts[] = { "AUTO", "NORMAL", "GOOD", "SPECOPS" };
    values[] = { "AUTO", "NORMAL", "GOOD", "SPECOPS" };
    default = "NORMAL";
    function = "SAS_Skills_fnc_paramSkills";

}
#endif
//<--Mission parameters





