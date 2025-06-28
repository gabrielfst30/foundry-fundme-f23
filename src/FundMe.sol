// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    //key do tipo address e valor do tipo uint256
    mapping(address => uint256) private s_addressToAmountFunded;
    //array de endereços
    address[] private s_funders;

    // Could we make this constant?  /* hint: no! We should make it immutable! */
    address private immutable i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    AggregatorV3Interface private s_priceFeed; //variável para armazenar o preço do feed

    //Contrutor para inicializar o contrato
    constructor(address priceFeed) {
        i_owner = msg.sender; //inicializa o owner com o endereço do contrato que está sendo deployado
        s_priceFeed = AggregatorV3Interface(priceFeed); //inicializa o priceFeed com o endereço do feed que está sendo passado como parâmetro
    }

    function fund() public payable {
        /*
         "Verifique se o valor em ETH que a pessoa está enviando, 
         quando convertido para dólares, é maior ou igual a 5 USD. 
         Se não for, reverta a transação e mostre a mensagem 'You need to spend more ETH!'"
         */
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "You need to spend more ETH!");
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version(); //retorna a versão do priceFeed
    }

    modifier onlyOwner() {
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    //Lendo o s_funders apenas uma vez em uma memory variable para economizar gas
    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length; //Armazenando a array s_funders

            for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) { //percorrendo fundersLength (financiadores)
            address funder = s_funders[funderIndex]; //armazenando o address dos financiadores
            s_addressToAmountFunded[funder] = 0; //setando o amount para zero (zerando carteiras dos financiadores)
        }

        s_funders = new address[](0); //criando um novo array de endereços vazio
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);

        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call - envia o saldo total do endereço para o dono do contrato.
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) { //percorrendo s_funders (financiadores)
            address funder = s_funders[funderIndex]; //armazenando todos os s_funders (financiadores)
            s_addressToAmountFunded[funder] = 0; //setando o amout para zero (zerando carteiras dos financiadores)
        }
        s_funders = new address[](0);
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);

        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \
    //         yes  no
    //         /     \
    //    receive()?  fallback()
    //     /   \
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    //-----View/Pure functions (Getters)

    //View que retorna o valor recebido pelo endereço
    function getAddressToAmountFunded(address fundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    //View que retorna todos os address do fundme
    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    //View que retorna o owner do contrato
    function getOwner() external view returns(address){
        return i_owner;
    }

}
