EC2_HOME=/home/ec2-user
AWS_CONFIG=$EC2_HOME/.aws
PROGNAME=asrcli

get_usage() {
    echo "usage: $PROGNAME <arg> [params]"
    echo "where <arg> is one of:"
    echo " - set - select CLI profile"
    echo " - configure [profile name] - configure new CLI profile"
    echo " - clear - de-select CLI profile"
    echo " - reset - delete all CLI profiles"
    echo " - whoami - lists the current profile being used"
    echo " - lsprofiles - lists all configured profiles"
    echo ""

    echo "NOTE: For Set, Clear, and Reset, you MUST use a dot (.) in front of the command"
    echo "Example: . $PROGNAME set admin"
}

if [[ $# == 2 ]]
then
    if [[ $1 == 'set' ]]
    then
        echo "export AWS_PROFILE=$2" > out.sh
        chmod 700 out.sh
        source out.sh
        rm out.sh
    else 
        echo "Invalid argument passed. Type '$PROGNAME help' for more info."
    fi
elif [[ $# == 1 ]]
then
    if [[ $1 == 'configure' ]]
    then
        echo 'IAM Role Arn: '
        read RoleArn
        echo 'Profile Name: '
        read ProfileName
        aws configure set credential_source Ec2InstanceMetadata --profile $ProfileName
        aws configure set role_arn $RoleArn --profile $ProfileName       
 
    elif [[ $1 == 'clear' ]]
    then
        unset AWS_PROFILE
    elif [[ $1 == 'reset' ]]
    then
        rm -rf $AWS_CONFIG
        unset AWS_PROFILE
    elif [[ $1 == 'help' ]]
    then
        get_usage
    elif [[ $1 == 'whoami' ]]
    then
        if [[ -z $AWS_PROFILE ]]
        then 
            echo "No profile is currently active"
        else
            echo "$AWS_PROFILE"
        fi
    elif [[ $1 == 'lsprofiles' ]]
    then
        if [[ ! -e $AWS_CONFIG/config ]]
        then
            echo "No profiles are configured"
        else
            cat $AWS_CONFIG/config
        fi
    else
        echo "Invalid argument passed. Type '$PROGNAME help' for more info."
    fi
else
    get_usage
fi
