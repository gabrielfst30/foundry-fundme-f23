// SPDX-License-Identifier: MIT

//1. Deploy the mocks quando estivermos na local anvil chain
//2. Controlar os contratos de diferentes chains
//SEPOLIA ETH/USD
//MAINNET ETH/USD

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    //Se estivermos em uma local anvil chain, vamos usar os mocks
    //Se estivermos em uma chain diferente, vamos usar os contratos que já existem

    //Vamos usar o activeNetworkConfig para controlar o contrato que vamos usar
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    //Tipando o price feed
    struct NetworkConfig {
        address priceFeed; //ETH/USD price feed address
    }

    //Se o chainId for 11155111, vamos usar o sepoliaConfig
    //Se o chainId for 31337, vamos usar o anvilConfig
    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    //Recebe o endereço do price feed do ETH/USD
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        //price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});

        return sepoliaConfig; //Retorna o endereço do price feed do ETH/USD
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        //Se o price feed já estiver configurado, retorna o price feed já configurado
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        //1. Deploy the mocks
        //2. Return the mock address

        vm.startBroadcast();
        //Faz o deploy do mock price feed no anvil chain
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});

        return anvilConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        //price feed address
        NetworkConfig memory ethConfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});

        return ethConfig; //Retorna o endereço do price feed do ETH/USD
    }
}
