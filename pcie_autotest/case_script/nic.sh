
g_flParent="${BASH_SOURCE[1]}"
g_fnCur=$(basename "${BASH_SOURCE[0]}")
g_dpCur=$(dirname  "${BASH_SOURCE[0]}")
drCur0=${PWD}
cd "${g_dpCur}" >/dev/null
g_dpCur=${PWD}
cd "${drCur0}" >/dev/null
g_pfnCur=${g_dpCur}/${g_fnCur}
export g_fn_nic_common=${g_fnCur}
export g_dp_nic_common=${g_dpCur}

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
	return 100
fi

export g_defSourceFiles=${g_defSourceFiles}$'\n'${g_pfnCur}
printf "%s[%3d]%5s: Load [${g_pfnCur}] call by [${g_flParent}]\n" "${FUNCNAME[0]}" ${LINENO} "Info"

####################################################################################
declare -A \
g_dicIPs1=(
    [0]=192.168.12.21
    [1]=192.168.13.22
)

declare -A \
g_dicIPs2=(
    [0]=192.168.12.31
    [1]=192.168.13.32
)

declare -A m_dicNicPair=()

export g_sDriverCard=

f_bRealDo2=true

InitNicPair()
{
    local varDicBoard1=${1}
    local varDicBoard2=${2}
    local sDriverName=${3}
    local sCardName=${4}
    local flLog=${5:-/dev/null}

    #####################
    sPF1=$(grep -F "${sCardName}_${sDriverName}" <<< "${g_sDriverCard}")
    if [ "${sPF1}" == "${sCardName}_${sDriverName}" ]; then
        g_sMsgCur="${sCardName}_${sDriverName} set already before"
        g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
        OutLogHead 0 "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${flLog}" false
        return 0
    fi

    #####################
    if ${f_bRealDo2}; then
    declare -A m_dicNicName1=()
    GetNicNameRemote "${varDicBoard1}" "${sDriverName}" "${sCardName}" m_dicNicName1 "${flLog}"

    declare -A m_dicNicName2=()
    GetNicNameRemote "${varDicBoard2}" "${sDriverName}" "${sCardName}" m_dicNicName2 "${flLog}"

    declare -p m_dicNicName1
    declare -p m_dicNicName2

    NicNamePair "${varDicBoard1}" "${varDicBoard2}" m_dicNicName1 m_dicNicName2 m_dicNicPair "${flLog}"
    declare -p m_dicNicPair

    declare -A m_dicIndexT=()
    SetIPByPairNicName m_dicNicName1 m_dicIndexT "" g_dicIPs1
    NicEthEnableRemote "${varDicBoard1}" m_dicNicName1 "${flLog}"
    
    SetIPByPairNicName m_dicNicName2 m_dicIndexT m_dicNicPair g_dicIPs2
    NicEthEnableRemote "${varDicBoard2}" m_dicNicName2 "${flLog}"

    declare -p m_dicNicName1
    declare -p m_dicNicName2
    else
    declare -A m_dicNicName1='([enP2p249s0f1]="" [enP2p249s0f0]="" )'
    declare -A m_dicNicName2='([enP2p249s0f1]="" [enP2p249s0f0]="" )'

    declare -A m_dicNicPair='([enP2p249s0f1]="enP2p249s0f1" [enP2p249s0f0]="enP2p249s0f0" )'
    fi

    export g_sDriverCard=${g_sDriverCard}$'\n'${sCardName}_${sDriverName}
}

