
g_flParent="${BASH_SOURCE[1]}"
g_fnCur=$(basename "${BASH_SOURCE[0]}")
g_dpCur=$(dirname  "${BASH_SOURCE[0]}")
drCur0=${PWD}
cd "${g_dpCur}" >/dev/null
g_dpCur=${PWD}
cd "${drCur0}" >/dev/null
g_pfnCur=${g_dpCur}/${g_fnCur}
export g_fn_payload_common=${g_fnCur}
export g_dp_payload_common=${g_dpCur}

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
#条件:cmdline add pci=pcie_bus_perf;
PayloadPerfI350()
{
    ArgInCmdLine "pci=pcie_bus_perf"
    if [ $? -ne 0 ]; then
        return 1
    fi

    CheckCard2KeysBA "I350" "MaxPayload 512 bytes, MaxReadReq 512 bytes"
    #or dmesg "Max Payload Size set to  512/ 512 (was  128), Max Read Rq  512"
}

PayloadPerf82599()
{
    ArgInCmdLine "pci=pcie_bus_perf"
    if [ $? -ne 0 ]; then
        return 1
    fi

    CheckCard2KeysBA "82599" "MaxPayload 512 bytes, MaxReadReq 512 bytes"
    #or dmesg "Max Payload Size set to  512/ 512 (was  128), Max Read Rq  512"
}

PayloadPerfP3600()
{
    ArgInCmdLine "pci=pcie_bus_perf"
    if [ $? -ne 0 ]; then
        return 1
    fi

    CheckCard2KeysBA "${g_sKeyP3600}" "MaxPayload 256 bytes, MaxReadReq 512 bytes"
    #or dmesg "Max Payload Size set to  256/ 256 (was  128), Max Read Rq  256"
}

