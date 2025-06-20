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

    address USER = makeAddr("user"); //criando endereço ficticio

    //Função de configuração que será executada antes de cada teste
    function setUp() external {
        //Instanciando contrato
        //fundMe é uma variável do tipo FundMe que recebe o contrato FundMe.
        DeployFundMe deployFundMe = new DeployFundMe(); //Instanciando o contrato DeployFundMe
        fundMe = deployFundMe.run(); //Atribuindo o contrato FundMe ao contrato fundMe
        vm.deal(USER, 10e18); //cheatcode para atribuir valor ao address USER criado
    }

    //Testando se o valor mínimo é 5
    function testMinimunDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
        console.log(fundMe.MINIMUM_USD());
    }

    //Testando se quem esta executando o contrato é o dono do contrato
    function testOwnerIsMsgSender() public view {
        //Testando se o owner é o address(this) que é o contrato que está sendo testado
        assertEq(fundMe.i_owner(), msg.sender);
        //Logando o owner
        console.log(fundMe.i_owner());
        //Logando o msg.sender
        console.log(msg.sender);
    }

    //Testando o retorno da versão do priceFeed
    function testPriceFeedVersionIsCorrect() public view {
        //Primeiro vamos chamar o valor para ver o que está retornando
        uint256 version = fundMe.getVersion();
        console.log("Price feed version:", version);

        //Depois fazemos a verificação
        assertEq(version >= 4, true);
    }

    //Força um teste de falha para quando a transação não enviar nenhum eth
    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert(); //cheatcode do foundry que força a falha da próxima linha/transação
        fundMe.fund(); //Chamando a funçao fund sem enviar nenhum ether
    }

    //Testando se a estrutura de dados atualiza após receber algum eth
    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); //cheatcode para fazer a próxima transação ser enviada por USER
        fundMe.fund{value: 10e18}(); //enviando 10 ETH
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER); //Pegando o address que envio o ether
        //Verificando se o address foi atualizado com o novo valor de ether enviado
        assertEq(amountFunded, 10e18);
    }
}
