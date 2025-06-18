// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

//Importando test
import {Test, console} from "forge-std/Test.sol";
//Importando contrato
import {FundMe} from "../src/FundMe.sol";

//Importando script de deploy
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

//Nomeando contrato e herdando de Test
contract FundMeTest is Test {
    //Variável do tipo FundMe
    FundMe fundMe;

    //Função de configuração que será executada antes de cada teste
    function setUp() external {
        //Instanciando contrato
        //fundMe é uma variável do tipo FundMe que recebe o contrato FundMe.
        DeployFundMe deployFundMe = new DeployFundMe(); //Instanciando o contrato DeployFundMe
        fundMe = deployFundMe.run(); //Atribuindo o contrato FundMe ao contrato fundMe
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
        assertEq(fundMe.i_owner(), msg.sender);
        //Logando o owner
        console.log(fundMe.i_owner());
        //Logando o msg.sender
        console.log(msg.sender);
    }

    //Função que será executada para testar o contrato
    function testPriceFeedVersionIsCorrect() public view {
        //Primeiro vamos chamar o valor para ver o que está retornando
        uint256 version = fundMe.getVersion();
        console.log("Price feed version:", version);
        
        //Depois fazemos a verificação
        assertEq(version >= 4, true);
    }

    //Força falha para quando a transação não enviar nenhum eth
    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert(); //Força a proxima transação a falhar
        fundMe.fund(); //Chamando a funçao fund sem enviar nenhum ether
    }


    function testFundUpdatesFundedDataStructure() public{
        fundMe.fund{value: 10e18}();
    }
}
