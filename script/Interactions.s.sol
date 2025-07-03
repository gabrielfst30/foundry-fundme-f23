//SPDX-License-Identifier: MIT

// Fund
// Withdraw

pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

//Script para financiar o contrato
contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether; //Valor constante para financiar o contrato (economiza gas)

    //Função principal para executar o script FundFundMe
    function run() external {
        //Criando uma variável para armazenar o contrato mais recentemente implantado
        address mostRecentlyDeployedContract = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        //Rodando a função fundFundMe
        fundFundMe(mostRecentlyDeployedContract);
    }

    //Função para financiar o contrato pegando o contrato mais recentemente implantado
    function fundFundMe(address mostRecentlyDeployedContract) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployedContract)).fund{value: SEND_VALUE}(); //Financiando o contrato com 0.01 ether
        console.log("Funded FundMe with 0.01 ETH: ", SEND_VALUE);
        vm.stopBroadcast();
    }
}

//Script para sacar o dinheiro do contrato
contract WithdrawFundMe is Script {
    //Função principal para executar o script FundFundMe
    function run() external {
        //Criando uma variável para armazenar o contrato mais recentemente implantado
        address mostRecentlyDeployedContract = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        //Rodando a função fundFundMe
        withdrawFundMe(mostRecentlyDeployedContract);
    }

    //Função para financiar o contrato pegando o contrato mais recentemente implantado
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw(); //Sacando o dinheiro do contrato
        vm.stopBroadcast();
        console.log("Withdraw FundMe balance!");
    }
}
