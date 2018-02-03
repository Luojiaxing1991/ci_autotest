#/bin/bash
function AutoNegotiation()
{
    ifconfig $NETPORT1 $LOCAL1_IP
    ssh root@$BACK_IP "ifconfig $NETPORT1 $REMOTE1_IP"
    ethtool -r eth1
    ping $REMOTE1_IP -c 5 $$ grep "0% packet loss"
    if [ $? = 0 ];then
        echo "ok"
    fi
}

function main()
{
    JIRA_ID="PV-439"
    Test_Item="Auto Negotiation Support"
    Designed_Requirement_ID="R.HNS.F006A"
    :> autoneg.log
}
