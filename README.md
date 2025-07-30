# 💰 FundMe - Smart Contract com Foundry

Este repositório contém a implementação do contrato inteligente **FundMe**, desenvolvido com o framework **Foundry**. O objetivo do contrato é permitir que usuários enviem fundos em ETH para o contrato, enquanto o dono do contrato pode retirar os fundos acumulados — usando **Chainlink Price Feeds** para conversão de valor em tempo real.

---

## 🔧 Tecnologias e Ferramentas

* [**Foundry**](https://book.getfoundry.sh/) – Framework rápido e eficiente para desenvolvimento em Solidity
* **Solidity 0.8.x** – Linguagem para smart contracts na EVM
* [**Chainlink Price Feeds**](https://docs.chain.link/data-feeds) – Para consultar o valor atual do ETH em USD
* [**Forge**](https://book.getfoundry.sh/forge/index.html) – Ferramenta de build, test e deploy do Foundry
* [**Anvil**](https://book.getfoundry.sh/anvil/index.html) – Blockchain local para testes

---

## 📁 Estrutura do Projeto

```bash
foundry-fundme-f23/
├── src/
│   ├── FundMe.sol              # Contrato principal
│   ├── PriceConverter.sol      # Biblioteca para converter ETH -> USD
│   └── interfaces/
│       └── AggregatorV3Interface.sol # Interface Chainlink
│
├── script/
│   └── DeployFundMe.s.sol      # Script de deploy usando Foundry
│
├── test/
│   ├── FundMeTest.t.sol        # Testes do contrato FundMe
│   └── MockV3Aggregator.sol    # Mock do oracle Chainlink para testes locais
│
├── lib/                        # Bibliotecas externas (via forge install)
├── .env                        # Arquivo para variáveis de ambiente
└── foundry.toml                # Configuração do projeto
```

---

## 🚀 Funcionalidades

* **Fund Function**: Qualquer usuário pode enviar ETH para o contrato.
* **Withdraw Function**: Apenas o dono do contrato pode sacar os fundos.
* **Price Feed Integration**: O contrato converte ETH para USD usando dados da Chainlink.
* **Modifiers de segurança**: Uso de `onlyOwner` para proteger a função de saque.
* **Mock de Oracle**: Testes locais utilizam `MockV3Aggregator` para simular o preço do ETH.

---

## 🧪 Como Executar Localmente

### Pré-requisitos

* Instalar [Foundry](https://book.getfoundry.sh/getting-started/installation)

### Instalação

```bash
# Clone o repositório
git clone https://github.com/gabrielfst30/foundry-fundme-f23.git
cd foundry-fundme-f23

# Instale as dependências
forge install

# Compile os contratos
forge build

# Execute os testes
forge test
```

---

## 🧠 Testes

O projeto inclui testes para:

* Fundamentos do contrato (`fund`, `withdraw`)
* Proteção do `onlyOwner`
* Conversão correta de ETH para USD
* Integração com oráculo mockado da Chainlink

---

## 🌎 Deploy em Testnets

Caso deseje fazer deploy em uma testnet (ex: Sepolia), configure sua `.env` com:

```env
RPC_URL=https://sepolia.infura.io/v3/SEU_PROJECT_ID
PRIVATE_KEY=SEU_PRIVATE_KEY
ETHERSCAN_API_KEY=SEU_API_KEY
```

E rode:

```bash
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast --verify
```

---

## 🧠 Conceitos abordados

* Integração com Chainlink Oracles
* Testes com mocks
* Modificadores de acesso
* Conversão de valor ETH/USD on-chain
* Deploy com scripts automatizados

---

## 📌 Autor

Desenvolvido por [**Gabriel Ritta**](https://github.com/gabrielfst30), fullstack e blockchain developer com foco em soluções descentralizadas e aplicações Web3.
