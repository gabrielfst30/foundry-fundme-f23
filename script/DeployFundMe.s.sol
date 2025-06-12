// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe){

        //Antes do broadcast, não implementamos na blockchain e não pagamos gas
        HelperConfig helperConfig = new HelperConfig(); //Instanciando o contrato HelperConfig
        (address priceFeed) = helperConfig.activeNetworkConfig(); //Desestruturando o struct NetworkConfig e pegando o priceFeed

        //Depois do broadcast, implementamos na blockchain e pagamos gas
        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeed);
        vm.stopBroadcast();
        return fundMe; //retorna o contrato FundMe
    }
}
