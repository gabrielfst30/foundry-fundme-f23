// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

//Importando test
import {Test, console} from "forge-std/Test.sol";
//Importando contrato
import {FundMe} from "../../src/FundMe.sol";

//Importando script de deploy
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

//Importando script de interações
import {FundFundMe} from "../../script/interactions.s.sol";

//Nomeando contrato e herdando de Test
contract InteractionsTest is Test {
     FundMe fundMe;

    address USER = makeAddr("user"); //criando endereço ficticio
    uint256 constant GAS_PRICE = 1;

    //Função de configuração que será executada antes de cada teste
    function setUp() external {
        //Instanciando contrato
        //fundMe é uma variável do tipo FundMe que recebe o contrato FundMe.
        DeployFundMe deployFundMe = new DeployFundMe(); //Instanciando o contrato DeployFundMe
        fundMe = deployFundMe.run(); //Atribuindo o contrato FundMe ao contrato fundMe
        vm.deal(USER, 10e18); //cheatcode para atribuir valor ao address USER criado
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe(); //Instanciando o contrato FundFundMe
        vm.prank(USER); //cheatcode para fazer a próxima transação ser enviada por USER
        vm.deal(USER, 10e18); //cheatcode para atribuir valor ao address USER criado
        fundFundMe.fundFundMe(address(fundMe)); //Rodando a função fundFundMe passando o endereço do contrato fundMe

        address funder = fundMe.getFunder(0); //Pegando o primeiro financiador pelo indice
        assertEq(funder, USER); //Comparando de o financiador é o USER
    }

}