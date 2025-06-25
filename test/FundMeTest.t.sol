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
    uint256 constant GAS_PRICE = 1;

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
        assertEq(fundMe.getOwner(), msg.sender);
        //Logando o owner
        console.log(fundMe.getOwner());
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

    //Testando se o financiado entrou para o array de financiadores
    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: 10e18}(); //enviando 10 ETH

        address funder = fundMe.getFunder(0); //Pegando o primeiro financiador pelo indice
        assertEq(funder, USER); //Comparando de o financiador é o USER
    }

    //Criando um modificador para enviarmos uma transação sem precisar repetir codigo em todas as funções
    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: 10e18}(); //enviando 10 ETH
        _;
    }

    //Testando se somente o owner do contrato pode sacar
    function testOnlyOwnerCanWithdrawn() public funded {
        vm.expectRevert(); //cheatcode do foundry que força a falha da próxima linha/transação
        vm.prank(USER); //USER fará a próxima transação
        fundMe.withdraw();
    }

    //Testando o saque com apenas um financiador
    function testWithDrawWithSingleFunder() public funded {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance; //pegando o balance inicial do owner
        uint256 startingFundMeBalance = address(fundMe).balance; //pegando o balance inicial do contato

        //Act 
        uint256 gasStart = gasleft(); //gas inicial antes da tx
        vm.txGasPrice(GAS_PRICE); //cheatcode para ativar o preço para todas as transações que forem executadas depois dessa linha, dentro do mesmo teste.
        vm.prank(fundMe.getOwner()); //owner fará a próxima transação
        fundMe.withdraw(); //sacando

        uint256 gasEnd = gasleft(); //gas final depois da tx
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice; //calculando o valor gasto de gás e multiplicando pelo valor atual do gás
        console.log(gasUsed);
        
        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance; //pegando o balance final do owner
        uint256 endingFundMeBalance = address(fundMe).balance; //pegando balance final do contrato
        assertEq(endingFundMeBalance, 0); //testando se o fundMe está com saldo 0
        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
    }

    //Testando a retirada de fundos de vários financiadores
    function testWithdrawnFromMultipleFunders() public funded {
        //Arrange
        uint160 numberOfFunders = 10; //número de financiadores 
        uint160 startingFunderIndex = 1; //indice

        
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            //hoax é a junção de um vm.prank com um vm.deal -> indica que a proxima transação será enviada por esse endereço e define o saldo do endereço ao mesmo tempo.
            hoax(address(i), 10e18); //definindo 10eth para todos os address percorridos pelo for
            fundMe.fund{value: 10e18}(); //enviando 10 ETH
        }

        //Act
        uint256 startingOwnerBalance = fundMe.getOwner().balance; //pegando o balance atual do owner
        uint256 startingFundMeBalance = address(fundMe).balance; //pegando o balance atual do contrato

        vm.prank(fundMe.getOwner()); //proxima transaçao será executada pelo owner
        fundMe.withdraw();

        //Assert
        assert(address(fundMe).balance == 0); //O contrato deve ter o valor de 0 ETH
        assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance); //Os valores iniciais antes de sacados, devem agora ser iguais ao do owner que fez o saque
    }
}
