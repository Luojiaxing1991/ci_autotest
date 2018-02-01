
g_flParent="${BASH_SOURCE[1]}"
g_fnCur=$(basename "${BASH_SOURCE[0]}")
g_dpCur=$(dirname  "${BASH_SOURCE[0]}")
drCur0=${PWD}
cd "${g_dpCur}" >/dev/null
g_dpCur=${PWD}
cd "${drCur0}" >/dev/null
g_pfnCur=${g_dpCur}/${g_fnCur}
export g_fn_prefetch_common=${g_fnCur}
export g_dp_prefetch_common=${g_dpCur}

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
Prefetch32b82599()
{
    DmesgCard2KeyBA "82599" 'BAR [0-9]\+: assigned \[mem [a-fxA-FX0-9-]\+ pref\]'
}
export -f Prefetch32b82599

Prefetch32bP3600()
{
    DmesgCard2KeyBA "${g_sKeyP3600}" 'BAR [0-9]\+: assigned \[mem [a-fxA-FX0-9-]\+ pref\]'
}
export -f Prefetch32bP3600

#####################
Prefetch64b82599()
{
    DmesgCard2KeyBA "82599" 'BAR [0-9]\+: assigned \[mem [a-fxA-FX0-9-]\+ 64bit pref\]'
}
export -f Prefetch64b82599

Prefetch64bP3600()
{
    DmesgCard2KeyBA "${g_sKeyP3600}" 'BAR [0-9]\+: assigned \[mem [a-fxA-FX0-9-]\+ 64bit pref\]'
}
export -f Prefetch64bP3600

#####################
Nonprefetch32bI350()
{
    #19e5:d113
    CheckCard2KeysBA "I350" "(32-bit, non-prefetchable)"
    if [ $? -ne 0 ]; then
        return 1
    fi

    DmesgCard2KeyBA "I350" 'BAR [0-9]\+: assigned \[mem [a-fxA-FX0-9-]\+\]'
}
export -f Nonprefetch32bI350

Nonprefetch32bVGA()
{
    CheckCard2KeysBA "19e5:1711" "(32-bit, non-prefetchable)"
    if [ $? -ne 0 ]; then
        return 1
    fi

    DmesgCard2KeyBA "VGA" 'BAR [0-9]\+: assigned \[mem [a-fxA-FX0-9-]\+\]'
}
export -f Nonprefetch32bVGA

#####################

