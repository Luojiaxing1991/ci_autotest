
g_flParent="${BASH_SOURCE[1]}"
g_fnCur=$(basename "${BASH_SOURCE[0]}")
g_dpCur=$(dirname  "${BASH_SOURCE[0]}")
drCur0=${PWD}
cd "${g_dpCur}" >/dev/null
g_dpCur=${PWD}
cd "${drCur0}" >/dev/null
g_pfnCur=${g_dpCur}/${g_fnCur}
export g_fn_enum_common=${g_fnCur}
export g_dp_enum_common=${g_dpCur}

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
if [ "${sPF1}" == "${g_pfnCur}" ]; then
    return 0
fi

export g_defSourceFiles=${g_defSourceFiles}$'\n'${g_pfnCur}
printf "%s[%3d]%5s: Load [${g_pfnCur}] call by [${g_flParent}]\n" "${FUNCNAME[0]}" ${LINENO} "Info"

####################################################################################
Enumeration82599()
{
    LspcikKeysiBA "Ethernet controller: Intel Corporation 82599ES 10-Gigabit"
}

EnumerationRaid3008()
{
    LspcikKeysiBA "SAS3008 PCI-Express"
}

EnumerationRaid3108()
{
    LspcikKeysiBA "LSI Logic / Symbios Logic MegaRAID SAS-3 3108"
}

EnumES3000()
{
    local nStat1=1

    LspcikKeysiBA "19e5:0123"
    nStat1=$?
    if [ ${nStat1} -ne 0 ]; then
        g_sMsgCur=
        LspcikKeysiBA "\<Huawei .\+ 0123\>" true
        nStat1=$?
    fi

    return ${nStat1}
}

