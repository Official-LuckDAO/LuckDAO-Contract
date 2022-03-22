const { hardhat } = require("hardhat");
const fs = require('fs'); 
let AWS = require('aws-sdk')
const path = require('path')

const dirPath = path.join(__dirname, '/deployParams.json')
let rawdata = fs.readFileSync(dirPath);
var params = JSON.parse(rawdata); 

console.log(params.name);

async function main() {
  const [deployer, addr1, addr2, ...addrs] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());
  

  // const Mooney = await ethers.getContractFactory("Mooney");
  // const mooney = await Mooney.deploy();
  // const mooneyAddr = mooney.address;
  // console.log("Mooney address:", mooneyAddr);
  // await mooney.deployed();
  // params.mooneyAddr=mooneyAddr;


  // const Lucky = await ethers.getContractFactory("Lucky");
  // const totalSuppl = params.totalSuppl_Luck_;
  // console.log("totalSuppl of Lucky = ", totalSuppl);
  // const lucky = await Lucky.deploy(totalSuppl);
  // const luckyAddr = lucky.address;
  // console.log("luckytoken address:", luckyAddr);
  // await lucky.deployed();
  // params.luckyAddr=luckyAddr;


  // var maxBatchSize_=params.NFTmaxBatchSize_;
  // var collectionSize_=params.NFTcollectionSize_;
  // var luckyAddr_=params.luckyAddr;//lucky.address;
  // const LuckDAOMeta = await ethers.getContractFactory('LuckDAOMeta');
  // const luckDAOMeta = await LuckDAOMeta.deploy(
  //   maxBatchSize_,collectionSize_,luckyAddr_
  // );
  // console.log("LuckDAOMeta address:", luckDAOMeta.address);
  // await luckDAOMeta.deployed();
  // params.metaNFTAddr=luckDAOMeta.address;


  // var luckyAddr_ = params.luckyAddr;
  // var metaNFTAddr_=params.metaNFTAddr; 
  // const LuckyAirdrop = await ethers.getContractFactory('LuckyAirdrop');
  // const luckyAirdrop = await LuckyAirdrop.deploy(
  //   luckyAddr_,
  //   metaNFTAddr_
  // );
  // console.log("LuckyAirdrop address:", luckyAirdrop.address);
  // await luckyAirdrop.deployed();
  // params.luckyAirdropAddr=luckyAirdrop.address;


  var subscriptionId_=params.subscriptionId_; 
  var metaNFTAddr_=params.metaNFTAddr;//luckDAOMeta.address
  var vrfCoordinator_ = params.vrfCoordinator_;
  var link_ = params.link_;
  var keyHash_  = params.keyHash_;
  const VRFv2ForLuck = await ethers.getContractFactory('VRFv2ForLuck');
  const vRFv2ForLuck = await VRFv2ForLuck.deploy(
    subscriptionId_,
    metaNFTAddr_,
    vrfCoordinator_ ,
    link_,
    keyHash_ 
  );
  console.log("vRFv2ForLuck address:", vRFv2ForLuck.address);
  await vRFv2ForLuck.deployed();
  params.vRFv2ForLuckAddr=vRFv2ForLuck.address;

  try {
    console.log("params:",params);
    const data = JSON.stringify(params, null, 4);
    fs.writeFileSync(dirPath, data);
    console.log("JSON data is saved.");
  } catch (error) {
    console.error(err);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });