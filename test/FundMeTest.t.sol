// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

//Importando test
import {Test, console} from "forge-std/Test.sol";
//Importando contrato
import {FundMe} from "../src/FundMe.sol";

//Nomeando contrato e herdando de Test
contract FundMeTest is Test {
    //Variável do tipo FundMe
    FundMe fundMe;
    //Função de configuração que será executada antes de cada teste

    function setUp() external {
        //Instanciando contrato
        //fundMe é uma variável do tipo FundMe que recebe o contrato FundMe.
        fundMe = new FundMe();
    }

    //Função que será executada para testar o contrato
    function testMinimunDollarIsFive() public view {
        //Testando se o valor mínimo é 5
        assertEq(fundMe.MINIMUM_USD(), 5e18);
        console.log(fundMe.MINIMUM_USD());
    }

    //Função que será executada para testar o contrato
    function testOwnerIsMsgSender() public view {
        //Testando se o owner é o address(this) que é o contrato que está sendo testado
        assertEq(fundMe.i_owner(), address(this));
        //Logando o owner
        console.log(fundMe.i_owner());
        //Logando o msg.sender
        console.log(msg.sender);
    }
}
