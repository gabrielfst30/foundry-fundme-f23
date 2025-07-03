-include .env

build:; forge build

deploy-sepolia: 
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC) --private-key $(PRIVATE_KEY) --broadcast -vvvv