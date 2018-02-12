
g_flParent="${BASH_SOURCE[1]}"
g_fnCur=$(basename "${BASH_SOURCE[0]}")
g_dpCur=$(dirname  "${BASH_SOURCE[0]}")
drCur0=${PWD}
cd "${g_dpCur}" >/dev/null
g_dpCur=${PWD}
cd "${drCur0}" >/dev/null
g_pfnCur=${g_dpCur}/${g_fnCur}
export g_fn_driver_backward_compatibility_common=${g_fnCur}
export g_dp_driver_backward_compatibility_common=${g_dpCur}

#####################
#check load from command line
if [ -z "${g_flParent}" ]; then
    #if at the command line, support reload the source file
    #delete it first
    g_defSourceFiles=$(grep -vF "${g_pfnCur}" <<< "${g_defSourceFiles}")
    #bug: export g_defSourceFiles=${g_defSourceFiles}${g_pfnCur}$'\n'
    #will delete the end line \n
fi

#check loaded already
sPF1=$(grep -F "${g_pfnCur}" <<< "${g_defSourceFiles}")
if [ $? -eq 0 ]; then
    #then [ "${sPF1}" == "${g_pfnCur}" ]
    #path file name is only one in file system.
	return 100
fi

export g_defSourceFiles=${g_defSourceFiles}$'\n'${g_pfnCur}
printf "%s[%3d]%5s: Load [${g_pfnCur}] call by [${g_flParent}]\n" "${FUNCNAME[0]}" ${LINENO} "Info"

####################################################################################
DriverEqulizationGen3P3600()
{
    #X4_gen3=$(devmem 0x700a0200080 32 |cut -c5-6)
    CheckCard2KeysBA "${g_sKeyP3600}" "LnkSta:[ ${g__t}]*Speed 8GT/s, Width x4,"
}

DriverEqulizationGen3Raid3008()
{
    #X8_gen3=$(devmem 0x8a0090080 32 |cut -c5-6)
    CheckCard2KeysBA "Symbios Logic SAS3008" "LnkSta:[ ${g__t}]*Speed 8GT/s, Width x8,"
}

DriverBackwardGen1VGA()
{
    #VGA compatible controller: Device 19e5:1711
    #X1_gen1=$(devmem 0x8a00b0080 32 |cut -c5-6)
    CheckCard2KeysBA "19e5:1711" "LnkSta:[ ${g__t}]*Speed 2.5GT/s, Width x1,"
    if [ $? -ne 0 ]; then
        return 1
    fi

    CheckCard2KeysBA "19e5:1711" "Kernel driver in use: hibmc-drm"
}

DriverBackwardGen2I350()
{
    CheckCard2KeysBA "I350" "LnkSta:[ ${g__t}]*Speed 5GT/s, Width x4,"
    if [ $? -ne 0 ]; then
        return 1
    fi

    CheckCard2KeysBA "I350" "Kernel driver in use: igb"
}

DriverBackwardGen282599()
{
    CheckCard2KeysBA "82599" "LnkSta:[ ${g__t}]*Speed 5GT/s, Width x8,"
    if [ $? -ne 0 ]; then
        return 1
    fi

    CheckCard2KeysBA "82599" "Kernel driver in use: ixgbe"
}

#####################

