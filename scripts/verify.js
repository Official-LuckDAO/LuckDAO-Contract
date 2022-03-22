const { hardhat } = require("hardhat");
const fs = require('fs'); 

let AWS = require('aws-sdk')
const path = require('path')
const dirPath = path.join(__dirname, '/deployParams.json')
let rawdata = fs.readFileSync(dirPath); 
const params = JSON.parse(rawdata);
console.log(params.name);

async function main() {

  try {
    await run("verify:verify", {
      address: params.mooneyAddr ,
      contract: "contracts/Mooney.sol:Mooney",
    });
  } catch (error) {
    console.log("error:", error.toString());
  }

  try { 
    await run("verify:verify", {
      address: params.luckyAddr,
      contract: "contracts/Lucky.sol:Lucky",
      constructorArguments: [
        params.totalSuppl_Luck_
      ],
    });
  } catch (error) {
    console.log("error:", error.toString());
  } 

  try { 
    await run("verify:verify", {
      address:  params.metaNFTAddr,
      contract: "contracts/LuckDAOMeta.sol:LuckDAOMeta",
      constructorArguments: [
        params.NFTmaxBatchSize_,
        params.NFTcollectionSize_,
        params.luckyAddr
      ],
    });
  } catch (error) {
    console.log("error:", error.toString());
  }


  try { 
    await run("verify:verify", {
      address:  params.luckyAirdropAddr ,
      contract: "contracts/LuckyAirdrop.sol:LuckyAirdrop",
      constructorArguments: [ 
        params.luckyAddr,
        params.metaNFTAddr
      ],
    });
  } catch (error) {
    console.log("error:", error.toString());
  }

  try {
    await run("verify:verify", {
      address: params.vRFv2ForLuckAddr,
      contract: "contracts/VRFv2ForLuck.sol:VRFv2ForLuck",
      constructorArguments: [
        params.subscriptionId_,
        params.metaNFTAddr,
        params.vrfCoordinator_,
        params.link_,
        params.keyHash_
      ],
    });
  } catch (error) {
    console.log("error:", error.toString());
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });