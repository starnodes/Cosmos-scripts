#!/bin/bash
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
WITHOU_COLOR='\033[0m'
DELEGATOR_ADDRESS='st1thzvljcqwy78r6rlfrqc245xdkzs50hus62zsn'
VALIDATOR_ADDRESS='stvaloper1thzvljcqwy78r6rlfrqc245xdkzs50hu8krzvc'
DELAY=3600/4 #in secs - how often restart the script
ACC_NAME=fiks_wallet
NODE="tcp://localhost:26657" #change it only if you use another rpc port of your node
CHAIN_NAME=tropos-1
project=stchaincli
coin=ustos
for (( ;; )); do
        echo -e "Get reward from Delegation"
        ${project} tx distribution withdraw-rewards ${VALIDATOR_ADDRESS} --chain-id ${CHAIN_NAME} --from ${DELEGATOR_ADDRESS} --gas=auto --fees=1000${coin} --commission --node ${NODE} --keyring-backend test --yes
for (( timer=30; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOUT_COLOR} sec\r" $timer
                sleep 1
        done
        BAL=$(${project} query account ${DELEGATOR_ADDRESS} -o json | jq -r '.value | .coins | .[].amount')
echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} ${coin}\n"
        echo -e "Claim rewards\n"
        ${project} tx distribution withdraw-all-rewards --from ${DELEGATOR_ADDRESS} --chain-id ${CHAIN_NAME} --gas=auto --fees=1000${coin} --keyring-backend test --yes
for (( timer=30; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
                sleep 1
        done
BAL=$(${project} query account ${DELEGATOR_ADDRESS} -o json | jq -r '.value | .coins | .[].amount');
        BAL=$(($BAL-1000000))
echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} ${coin}\n"
        echo -e "Stake ALL\n"
if (( BAL > 1000000 )); then
            ${project} tx staking delegate ${VALIDATOR_ADDRESS} ${BAL}${coin} --from ${DELEGATOR_ADDRESS} --gas=auto --fees=1000${coin} --node ${NODE} --chain-id ${CHAIN_NAME}  --keyring-backend test --yes
        else
                                echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} ${coin} BAL < 10000000 ((((\n"
        fi
for (( timer=${DELAY}; timer>0; timer-- ))
        do
            printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
            sleep 1
        done
done
