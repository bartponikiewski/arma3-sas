//-->Mission parameters
#ifdef sas_cfg_params
class SAS_Intro_Enabled 
{
    title = "Intro";
    texts[] = { "ENABLED", "DISABLED" };
    values[] = { 1, 0 };
    default = 1;
}

class SAS_Skills
{
    title = "Ai Skills";
    texts[] = {"AUTO", "NORMAL", "GOOD", "SPECOPS"};
    values[] = { 0, 1, 2, 3 };
    default = 1;
    function = "SAS_Skills_fnc_paramSkills";

}
#endif
//<--Mission parameters





