
g_flParent="${BASH_SOURCE[1]}"
g_fnCur=$(basename "${BASH_SOURCE[0]}")
g_dpCur=$(dirname  "${BASH_SOURCE[0]}")
drCur0=${PWD}
cd "${g_dpCur}" >/dev/null
g_dpCur=${PWD}
cd "${drCur0}" >/dev/null
g_pfnCur=${g_dpCur}/${g_fnCur}
export g_fn_run_iperf_common=${g_fnCur}
export g_dp_run_iperf_common=${g_dpCur}

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
LoadSourceFileParent "${g_dp_runcmd_common}" "nic.sh" flPath1 "${g_flLog}" true
$(sed "s#^#. #" <<< "${flPath1}")

f_bRealDo1=true
f_bMoveTmpLog=false

#####################
RunIperf()
{
    local varDicMCLogin=${1}
    local sIPBind=${2}
    local sIPClient=${3}
    local nRunLong=${4}
    local nfPerfDef=${5}
    local nTimesRun=${6}
    local bKillProc=${7}
    local flLog=${8:-/dev/null}

    #####################
    local sKeysA dicListA
    sKeysA="
        kDrLocalLog
        kDrTmpLog
        kDrProperLog
    "
    dicListA="
        ${varDicMCLogin}
        g_dicMCSame
    "
    FillDicByList sKeysA dicListA "${varDicMCLogin}"

    #####################
    nfPerfDef=$(sed "s@\(b\)its/sec@\1/s@Ig" <<< "${nfPerfDef}")

    grep -q "^[0-9]\+\$" <<< "${nTimesRun}"
    if [ $? -ne 0 ]; then
        g_sMsgCur="run times parameter[${nTimesRun}] not correct"
        g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
        OutLogHead 1 "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${flLog}" false
        return 1
    fi

    #####################
    #iperf -B 192.168.12.22 -c 192.168.12.82 -i 3 -t 60
    local f_sCmd f_nWait
    f_sCmd="iperf"
    f_nWait=1
    if [ -n "${sIPBind}" ]; then
        f_sCmd="${f_sCmd} -B ${sIPBind}"
    fi
    if [ -n "${sIPClient}" ]; then
        f_sCmd="${f_sCmd} -c ${sIPClient}"
    fi
    f_sCmd=${f_sCmd}' -i 3 -t ${m_dic[0]}'

    #####################
    local nCols=0
    declare -A m_dicValue=()
    local nR1 nC1
    nR1=0
    nC1=0
    while [ ${nR1} -lt ${nTimesRun} ]; do
        m_dicValue[${nR1}_${nC1}]="${nRunLong}"
        let nC1+=1

        nCols=${nC1}
        nC1=0
        let nR1+=1
    done

    #####################
    local drTmpLogLocal
    eval drTmpLogLocal=\${${varDicMCLogin}[kDrLocalLog]}/\${${varDicMCLogin}[kDrTmpLog]}
    if ${f_bRealDo1}; then
    SafeRemoveFolder "/logs/" "${drTmpLogLocal}" "${flLog}"

    local m_sTrapRuned
    m_sTrapRuned='
        -re {bind failed:} {
            set m_nStatusProc 2
        }
        -re {connect failed:} {
            set m_nStatusProc 3
        }
    '
    RunACmdsRemote "${varDicMCLogin}" g_loadSourceFile f_sCmd m_dic "${nCols}" m_dicValue "${f_nWait}" m_sTrapRuned "${bKillProc}" "${flLog}"
    fi

    #####################
    local sFlList s1 nPerf1

    sFlList=$(find "${drTmpLogLocal}" -maxdepth 1 -type f)
    if [ -z "${sFlList}" ]; then
        g_sMsgCur="no data files in [${drTmpLogLocal}]"
        g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
        OutLogHead 1 "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${flLog}" false
        return 1
    fi

    IFS=$'\n' #解决文件名有空格;
    #[ ID] Interval       Transfer     Bandwidth
    s1=$(sed -n "/Interval[ \t]\+Transfer[ \t]\+Bandwidth/I,\${p}" ${sFlList})
    IFS=${g_IFS0}
    s1=$(sed -n "/[ \t]\+[0-9.]\+[ \t]*[KMGT]bits\/sec[ \t]*\$/Ip" <<< "${s1}")

    OutLogHead 0 "" "" $'\n'"${s1}" "${flLog}" false

    #[  3] 15.0-18.0 sec  12.5 GBytes  35.9 Gbits/sec
    #[  3] 21.0-24.0 sec   336 MBytes   940 Mbits/sec
    nPerf1=$(sed "s@^.*[ \t]\+\([0-9.]\+\)[ \t]*\([KMGT]\)bits/sec[ \t]*\$@\1\2b/s@" <<< "${s1}")
    if [ -z "${nPerf1}" ]; then
        g_sMsgCur="not found data, data files or unit or key not correct?"
        g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
        OutLogHead 1 "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${flLog}" false
        return 1
    fi

    #####################
    local sMsg1
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
        sMsg1="compare [${nfPerfDef}] VS [${sR1}]"
        NumCmpKMGT "${sR1}" "${nfPerfDef}" 1024 nStat1
        if [ $? -lt 2 ]; then
            let nReach+=1
            sMsg1="${sMsg1} reached"
        fi
        echo "${sMsg1}"
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
    if ${f_bMoveTmpLog}; then
    local drStoreLogLocal
    eval drStoreLogLocal=\${${varDicMCLogin}[kDrLocalLog]}/\${${varDicMCLogin}[kDrProperLog]}
    mkdir -p "${drStoreLogLocal}"
    mv "${drTmpLogLocal}"/* "${drStoreLogLocal}"
    fi

    #####################
    return ${nStat1}
}

#####################
RunIperfUser()
{
    local sCardName=${1}
    local nfPerfDef=${2}
    local nNetPort=${3}
    local nTimeSecR=${4:-60}
    local nTimesRun=${5:-3}

    #####################
    local ip1
    eval ip1=\${${g_varDicBoard2}[kIP]}
    if [ -z "${ip1}" ]; then
        g_sMsgCur="remote ip is empty"
        g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
        OutLogHead 1 "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${g_flLog}" false
        return 1
    fi

    grep -q "^[0-9]\+\$" <<< "${nNetPort}"
    if [ $? -ne 0 ]; then
        g_sMsgCur="net port need number"
        g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
        OutLogHead 1 "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${g_flLog}" false
        return 1
    fi

    #####################
    local sDriverName=
    case "${sCardName}" in
    82599)
        grep -q "^[01]\$" <<< "${nNetPort}"
        if [ $? -ne 0 ]; then
            g_sMsgCur="net port need 0 or 1 for ${sCardName}"
            g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
            OutLogHead 1 "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${g_flLog}" false
            return 1
        fi

        sDriverName=ixgbe
        Enumeration82599
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

    InitNicPair "${g_varDicBoard1}" "${g_varDicBoard2}" "${sDriverName}" "${sCardName}" "${g_flLog}"

    #####################
    local sIP2
    eval sIP2=\${g_dicIPs2[${nNetPort}]}

    if ${f_bRealDo1}; then
    local sCmd1="iperf -s -B ${sIP2}"
    sCmd2=$(sed 's@"@\\"@g' <<< "${sCmd1}")
    local f_sCmdsEx="
        exp_send {
            \${SHELL} -c '
                KillAProcs \"${sCmd2}\"
                ${sCmd1} &
            '
        }
        expect {
            -re {bind failed:} {
                set m_iStatusExp 112
            }
            -re {Server listening on TCP port [0-9]+} {
                set m_iStatusExp 0
            }
        }
    "
    local g_sEnvLoad=
    RemoteExecCmds "${g_varDicBoard2}" g_sEnvLoad "" "" f_sCmdsEx "" "${g_flLog}"
    if [ $? -ne 0 ]; then
        g_sMsgCur="server not ready"
        g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
        OutLogHead 1 "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${g_flLog}" false
        return 1
    fi
    fi

    eval ${g_varDicBoard1}[kDrTmpLog]='${g_dicMCSame[kDrTmpLog]}${nNetPort}'
    RunIperf "${g_varDicBoard1}" "" "${sIP2}" "${nTimeSecR}" "${nfPerfDef}" "${nTimesRun}" false "${g_flLog}"
    if [ $? -ne 0 ]; then
        g_sMsgCur="RunIperf failed"
        g_sHeadCurLine=$(printf "%s[%3d]%s[%3d]" "${FUNCNAME[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" ${LINENO})
        OutLogHead 1 "" "${g_sHeadCurLine}" "${g_sMsgCur}" "${g_flLog}" false
        return 1
    fi

    return 0
}

