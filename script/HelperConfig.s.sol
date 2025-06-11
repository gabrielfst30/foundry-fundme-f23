// SPDX-License-Identifier: MIT

//1. Deploy the mocks quando estivermos na local anvil chain
//2. Controlar os contratos de diferentes chains

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    //Se estivermos em uma local anvil chain, vamos usar os mocks
    //Se estivermos em uma chain diferente, vamos usar os contratos que já existem

    struct NetworkConfig {
        address priceFeed; //ETH/USD price feed address
    }

    function getSepoliaEthConfig() public pure {
        //price feed address

    }

    function getAnvilEthConfig() public pure {
        //price feed address

    }
}