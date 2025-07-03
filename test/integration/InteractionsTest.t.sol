// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

//Importando test
import {Test, console} from "forge-std/Test.sol";
//Importando contrato
import {FundMe} from "../../src/FundMe.sol";

//Importando script de deploy
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

//Importando script de interações
import {FundFundMe, WithdrawFundMe} from "../../script/interactions.s.sol";

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

    //Teste para verificar se o usuário pode financiar e sacar o dinheiro do contrato
    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe(); //Instanciando o contrato FundFundMe
        fundFundMe.fundFundMe(address(fundMe)); //Rodando a função fundFundMe passando o endereço do contrato fundMe

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe(); //Instanciando o contrato WithdrawFundMe
        withdrawFundMe.withdrawFundMe(address(fundMe)); //Rodando a função withdrawFundMe passando o endereço do contrato fundMe

        assert(address(fundMe).balance == 0); //Verificando se o saldo do contrato fundMe é 0
    }

}