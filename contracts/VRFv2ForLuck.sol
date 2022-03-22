// SPDX-License-Identifier: MIT
// An example of a consumer contract that relies on a subscription for funding.
pragma solidity ^0.8.6;

import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VRFv2ForLuck is Ownable,VRFConsumerBaseV2 {
  VRFCoordinatorV2Interface COORDINATOR;
  LinkTokenInterface LINKTOKEN;
  bytes32 keyHash ;
    // Your subscription ID.
  uint64 public s_subscriptionId;
  address public nftContractAddr;   
  uint public maxLen;
  uint16 requestConfirmations = 10;
  uint32 numWords =  1; 
  uint256 public s_requestId;
  uint public winner;

  //events
  event DiceRolled(uint256 indexed requestId, uint256 indexed s_randomWord,uint256 indexed winner);

  function setsubscript_nft(
      uint64 subscriptionId_,
      address nftContractAddr_
    )external onlyOwner {
    s_subscriptionId=subscriptionId_;
    nftContractAddr=nftContractAddr_;    
  }


  constructor(
    uint64 subscriptionId_, 
    address nftContractAddr_,  //0xCaD0A96b3B0fda25bA9C069913CA456833598a4E
    address vrfCoordinator_,// = 0x6168499c0cFfCaCD319c818142124B7A15E857ab;
    address link_ ,//= 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;
    bytes32 keyHash_ // = 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;
  ) VRFConsumerBaseV2(vrfCoordinator_) {
    COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator_);
    LINKTOKEN = LinkTokenInterface(link_);
    keyHash=keyHash_;
    s_subscriptionId = subscriptionId_;
    nftContractAddr=nftContractAddr_;
  }

  // Assumes the subscription is funded sufficiently.
  // Will revert if subscription is not set and funded.    
  function RollTheDice() external onlyOwner {
    maxLen=IERC721Enumerable(nftContractAddr).totalSupply();
    uint32 callbackGasLimit = 100000+60000*numWords;
    s_requestId = COORDINATOR.requestRandomWords(
      keyHash,
      s_subscriptionId,
      requestConfirmations,
      callbackGasLimit,
      numWords
    );
  } 
  
  function fulfillRandomWords(
    uint256 , /* requestId */
    uint256[] memory randomWords
  ) internal override {
    uint s_randomWord = randomWords[0];
    winner= s_randomWord % maxLen;
    emit DiceRolled(s_requestId,s_randomWord,winner);
  }

}
