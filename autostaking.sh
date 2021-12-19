#!/bin/bash
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
WITHOU_COLOR='\033[0m'
DELEGATOR_ADDRESS='evmos...'
VALIDATOR_ADDRESS='evmosvaloper...'
PWD='PWD'
DELAY=3600/4 #in secs - how often restart the script
ACC_NAME= #example: = ACC_NAME=wallet30
NODE="tcp://localhost:26657" #change it only if you use another rpc port of your node
CHAIN_NAME=evmos_9000-2
for (( ;; )); do
        echo -e "Get reward from Delegation"
        echo -e "${PWD}\ny\n" | evmosd tx distribution withdraw-rewards ${VALIDATOR_ADDRESS} --chain-id ${CHAIN_NAME} --from ${DELEGATOR_ADDRESS} --gas=auto --fees=1000aphoton --commission --node ${NODE} --yes
for (( timer=30; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOUT_COLOR} sec\r" $timer
                sleep 1
        done
BAL=$(evmosd q bank balances ${DELEGATOR_ADDRESS} --node ${NODE} -o json | jq -r '.balances | .[].amount')
echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} aphoton\n"
        echo -e "Claim rewards\n"
        echo -e "${PWD}\n${PWD}\n" | evmosd tx distribution withdraw-all-rewards --from ${DELEGATOR_ADDRESS} --chain-id ${CHAIN_NAME} --gas=auto --fees=1000aphoton --node ${NODE} --yes
for (( timer=30; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
                sleep 1
        done
BAL=$(evmosd q bank balances ${DELEGATOR_ADDRESS} --node ${NODE} -o json | jq -r '.balances | .[].amount');
        BAL=$(($BAL-1000000))
echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} aphoton\n"
        echo -e "Stake ALL\n"
if (( BAL > 1000000 )); then
            echo -e "${PWD}\n${PWD}\n" | evmosd tx staking delegate ${VALIDATOR_ADDRESS} ${BAL}aphoton --from ${DELEGATOR_ADDRESS} --gas=auto --fees=1000aphoton --node ${NODE} --chain-id ${CHAIN_NAME}  --yes
        else
                                echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} aphoton BAL < 10000000 ((((\n"
        fi
for (( timer=${DELAY}; timer>0; timer-- ))
        do
            printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
            sleep 1
        done
done
