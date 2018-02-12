
g_flParent="${BASH_SOURCE[1]}"
g_fnCur=$(basename "${BASH_SOURCE[0]}")
g_dpCur=$(dirname  "${BASH_SOURCE[0]}")
drCur0=${PWD}
cd "${g_dpCur}" >/dev/null
g_dpCur=${PWD}
cd "${drCur0}" >/dev/null
g_pfnCur=${g_dpCur}/${g_fnCur}
export g_fn_runcmd_common=${g_fnCur}
export g_dp_runcmd_common=${g_dpCur}

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
LoadSourceFileParent "${g_dp_runcmd_common}" "enum.sh" flPath1 "${g_flLog}" true
$(sed "s#^#. #" <<< "${flPath1}")

RunFio()
{
    local tRW=${1}
    local bsU=${2}
    local nfPerfDef=${3}
    local sDiskName=${4}
    local nTimesRun=${5}
    local sPosName=${6}
    local flLog=${7:-/dev/null}

    #####################
    grep -q "^[0-9]\+\$" <<< "${nTimesRun}"
    if [ $? -ne 0 ]; then
        g_sMsgCur="run times parameter[${nTimesRun}] not correct"
        g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
        OutLogHead 1 "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${flLog}" false
        return 1
    fi

    #####################
    declare -A \
    g_dicLib1_B136=(
        [kDrLoad]=${g_dp_pcie_test_common}
	    [kMDrLog]='${HOME}/tmp/data/logs'
    )

    #fio --name=read --rw=read --bs=1M --runtime=30 --filename=/dev/nvme0n1 --numjobs=32 --iodepth=128 --direct=1 --sync=0 --norandommap --group_reporting --time_based
    local m_sCmd
    m_sCmd='false'
    m_sCmd='fio --name=${m_dic[0]} --rw=${m_dic[0]} --bs=${m_dic[1]} --filename=/dev/${m_dic[2]} --runtime=30 --numjobs=32 --iodepth=128 --direct=1 --sync=0 --norandommap --group_reporting --time_based'

    local nCols=0
    local m_sTrapRuned
    declare -A m_dicValue=()
    local nR1 nC1

    #####################
    nR1=0
    nC1=0
    while [ ${nR1} -lt ${nTimesRun} ]; do
        m_dicValue[${nR1}_${nC1}]="${tRW}"
        let nC1+=1

        m_dicValue[${nR1}_${nC1}]="${bsU}"
        let nC1+=1

        m_dicValue[${nR1}_${nC1}]="${sDiskName}"
        let nC1+=1

        nCols=${nC1}
        nC1=0

        let nR1+=1
    done

    #####################
    local drLocalLogs
    drLocalLogs=${g_dicLib1_B136[kMDrLog]}
    drLocalLogs=${HOME}/tmp/data/logs
    SafeRemoveFolder "/logs/" "${drLocalLogs}/${g_dicMCSame[kDrTmpLog]}" "${flLog}"

    m_sTrapRuned="
    "
    RunACmdsRemote g_dicLib1_B136 "pcie_test_lib" "${m_sCmd}" m_dic ${nCols} m_dicValue 1 m_sTrapRuned true "${flLog}"

    #####################
    local sFlList s1 nPosV nPerf1

    sFlList=$(find "${drLocalLogs}/${g_dicMCSame[kDrTmpLog]}" -maxdepth 1 -type f)
    if [ -z "${sFlList}" ]; then
        g_sMsgCur="no data files in [${drLocalLogs}/${g_dicMCSame[kDrTmpLog]}]"
        g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
        OutLogHead 1 "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${flLog}" false
        return 1
    fi

    IFS=$'\n' #解决文件名有空格;
    s1=$(sed -n "/^[ \t]*${tRW}[ \t]*:/{n;/^[ \t]*\(read\|write\)[ \t]*:/p}" ${sFlList})
    IFS=${g_IFS0}

    g_sMsgCur=$'\n'"${s1}"
    g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
    OutLogHead 0 "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${flLog}" false

    case "${sPosName}" in
    bw)
        nfPerfDef=$(sed "s#/s\$##" <<< "${nfPerfDef}")
        nPosV=2
        ;;
    iops)
        nPosV=3
        ;;
    *)
        g_sMsgCur="not know position name [${sPosName}]"
        g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
        OutLogHead 1 "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${flLog}" false
        return 1
    esac

    #read : io=75794MB, bw=2525.1MB/s, iops=2525, runt= 30006msec
    nPerf1=$(sed -n "s#^[ \t]*\(read\|write\)[ \t]*:[^,]\+, bw=\([0-9.]\+[KMGT]B\)/s, iops=\([0-9]\+\), .*\$#\\${nPosV}#p" <<< "${s1}")
    if [ -z "${nPerf1}" ]; then
        g_sMsgCur="not found data, data files or unit or key not correct?"
        g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
        OutLogHead 1 "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${flLog}" false
        return 1
    fi

    #####################
    local nMax1 nR1 sR1 nReach sRMax nStat1
    nMax1=$(sed -n '$=' <<< "${nPerf1}")
    nR1=1
    sR1=$(sed -n "${nR1}p" <<< "${nPerf1}")
    nReach=0
    nStat1=0
    NumCmpKMGT "${sR1}" "${nfPerfDef}" 1024 nStat1
    if [ $? -lt 2 ]; then
        let nReach+=1
    fi
    sRMax=${sR1}
    while [ ${nR1} -lt ${nMax1} ]; do
        let nR1+=1
        sR1=$(sed -n "${nR1}p" <<< "${nPerf1}")
        NumCmpKMGT "${sR1}" "${nfPerfDef}" 1024 nStat1
        if [ $? -lt 2 ]; then
            let nReach+=1
        fi
        NumCmpKMGT "${sR1}" "${sRMax}" 1024 nStat1
        if [ $? -eq 1 ]; then
            sRMax=${sR1}
        fi
    done

    #####################
    if [ ${nStat1} -eq 0 ]; then
        let nStat1=\!nReach
        g_sMsgCur="${tRW}: run [nMax1]times, max value[${sRMax}], reached ${nfPerfDef} [${nReach}]times."
    fi
    g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
    OutLogHead "${nStat1}" "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${flLog}" false

    #####################
    mkdir -p "${drLocalLogs}/${g_dicMCSame[kDrProperLog]}"
    mv "${drLocalLogs}/${g_dicMCSame[kDrTmpLog]}"/* "${drLocalLogs}/${g_dicMCSame[kDrProperLog]}"

    #####################
    return ${nStat1}
}

#####################
RunFioUser()
{
    local tReadWrite=${1}
    local nfPerfDef=${2}
    local sCardName=${3}
    local sDiskName=${4}
    local nTimesRun=${5:-3}

    case "${sCardName}" in
    3108)
        EnumerationRaid3108
        ;;
    3008)
        EnumerationRaid3008
        ;;
    ES3000)
        EnumES3000
        ;;
    *)
        g_sMsgCur="card[${sCardName}] not defined"
        g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
        OutLogHead 1 "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${g_flLog}" false
        return 1
        ;;
    esac
    if [ $? -ne 0 ]; then
        g_sMsgCur="card[${sCardName}] not exist"
        g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
        OutLogHead 1 "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${g_flLog}" false
        return 1
    fi

    case "${tReadWrite}" in
    read|write)
        RunFio "${tReadWrite}" 1m "${nfPerfDef}" "${sDiskName}" "${nTimesRun}" bw "${g_flLog}"
        ;;
    randread|randwrite)
        RunFio "${tReadWrite}" 4k "${nfPerfDef}" "${sDiskName}" "${nTimesRun}" iops "${g_flLog}"
        ;;
    esac
}

