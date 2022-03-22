LuckDAO Hardhat Project
=======================

npm install @openzeppelin/contracts  
npm install @chainlink/contracts --save  
npm install --save-dev @nomiclabs/hardhat-etherscan   
npm i @nomiclabs/hardhat-waffle   
npm install --save-dev @nomiclabs/hardhat-ethers 'ethers@\^5.0.0'   
npm install --dotenv-extended  
npm i hardhat-gas-reporter   
npm i solidity-coverage   
npm i fs   
npm i aws-sdk

<!-- deploy and verify contracts -->
npx hardhat clean   
npx hardhat run --network rinkeby scripts/deploy.js  
npx hardhat run --network rinkeby scripts/verify.js  

<!-- 
deploy at mainnet change to: --network mainnet
deploy parameters and deployed addresses are saved in scripts/deployParams.json

verify a single contract:
npx hardhat verify --network rinkeby --contract contracts/Mooney.sol:Mooney  <your deployed address> 
-->
```
Contracts
=========

five contracts: 
1. Mooney.sol :
	A simple ERC20 contract 
2. Lucky.sol :
	An ERC20 contract with ERC20Votes, ERC20Snapshot and ERC20FlashMint 
3. LuckDAOMeta.sol: 
	An ERC271 contract, whitelist and Lucklist as two mapping can be set. whitelist price can be set. Lucklist price is zero.
	Public sale price and time can be set. Burn token at luckyAddr when whiteluckyBurn_ or publicluckyBurn_ is greater than zero.
	publicSaleStartTime_ can be set (to be 0 or to be a future timestamp).
	flip _isPublicSaleActive to set public-sale open or closed. 
4. LuckyAirdrop.sol
	Airdrop luckytoken to lucky addresses through LuckeyAirdrop() by contract owner, and to LuckymetaNFT holders through 	NFTAirDropClaim() by holders themselves. The amount of both Airdrops can be set through setdropNum(). 

5. VRFv2ForLuck 
	Use chainlink VRF-v2 to randomly pick up the winner in 0 to maxLen-1, which is identical to NFT's ID. 
	The maxLen is LuckDAOMeta.totalSupply(). Have to add deployed address of this contract as a consumer to your Chainlink VRF subscription. 
	To pick up the winner, the owner of this contract calls RollTheDice() to call chainlink VRF service. After about 10 block time, there will be a new transaction sent from vrfCoordinator, the result will be written in the log "DiceRolled" of it.
    address winnerAddress=IERC721(nftContractAddr).ownerOf(winner);
    Docs of VRF(Verifiable Random Function) https://docs.chain.link/docs/chainlink-vrf/

deployed addresses at rinkeby testnet: 
mooneyAddr: '0xB2e1582349C9561E1a5584C16EeE087B6179463d',
luckyAddr: '0x3C0c2a151ADaEDc08a06541FADEDC730Ef354406', 
metaNFTAddr: '0x3e6Bea6DdAe7d7ECab4Fd2263682e07a3e8e5Eac', 
luckyAirdropAddr: '0x16fc46D96A3656d67c0783e8288547D0854d5678', 
vRFv2ForLuckAddr: '0x1ECC54dA41dc41Ca7733F9cf983dF5a85973BFBD'
