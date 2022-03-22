// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LuckDAOMeta is Ownable, ERC721A, ReentrancyGuard {
  uint256 public immutable maxPerAddressDuringMint;    
  address public luckyAddr;
  bool public _isPublicSaleActive = false;

  //Lucklist and white list only mint one
  // no burning for now
 
  mapping(address => uint256) public whitelist;
  mapping(address => uint256) public Lucklist;

  struct SaleConfig { 
    uint32 publicSaleStartTime;
    uint64 whitelistPrice;
    uint64 publicPrice;
    uint256 whiteluckyBurn;
    uint256 publicluckyBurn; 
  }  

  SaleConfig public saleConfig;  

  constructor(
    uint256 maxBatchSize_,
    uint256 collectionSize_,
    address luckyAddr_
  ) ERC721A("LuckDAOMeta", "LuckTicket", maxBatchSize_, collectionSize_) { 
    luckyAddr=luckyAddr_;
    maxPerAddressDuringMint = maxBatchSize_;  
  }

    function flipSaleActive() external onlyOwner {
        _isPublicSaleActive = !_isPublicSaleActive;
    }

  function SetupSaleInfo(
    uint64 whitelistPriceWei_,
    uint64 publicPriceWei_,
    uint256 whiteluckyBurn_,
    uint256 publicluckyBurn_,
    uint32 publicSaleStartTime_
  ) external onlyOwner {
    saleConfig = SaleConfig( 
      publicSaleStartTime_,
      whitelistPriceWei_,
      publicPriceWei_,
      whiteluckyBurn_,
      publicluckyBurn_
    );
  }

  modifier callerIsUser() {
    require(tx.origin == msg.sender, "The caller is another contract");
    _;
  }

  function LucklistMint() external callerIsUser {   //only mint one
    require(Lucklist[msg.sender] > 0, "not eligible for Lucklist mint");
    require(totalSupply() + 1 <= collectionSize, "reached max supply");
    Lucklist[msg.sender]--;
    _safeMint(msg.sender, 1);
  }

  function whitelistMint() external payable callerIsUser {  //only mint one
    uint256 price = uint256(saleConfig.whitelistPrice);
    require(price != 0, "whitelist sale has not begun yet");
    require(whitelist[msg.sender] > 0, "not eligible for whitelist mint");
    require(totalSupply() + 1 <= collectionSize, "reached max supply");
    whitelist[msg.sender]--;
    SaleConfig memory config = saleConfig; 
    if(config.whiteluckyBurn>0)IERC20(luckyAddr).transferFrom(msg.sender,
        0x000000000000000000000000000000000000dEaD, 
        config.whiteluckyBurn);
    _safeMint(msg.sender, 1);
    refundIfOver(price);
  }

  function publicSaleMint(uint256 quantity)
    external
    payable
    callerIsUser
  {
    SaleConfig memory config = saleConfig; 
    uint256 publicPrice = uint256(config.publicPrice);
    uint256 publicSaleStartTime = uint256(config.publicSaleStartTime);

    require(
      isPublicSaleOn(publicPrice, publicSaleStartTime),
      "public sale has not begun yet"
    );
    require(totalSupply() + quantity <= collectionSize, "reached max supply");
    require(
      numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
      "can not mint this many"
    );
    if(config.publicluckyBurn>0)IERC20(luckyAddr).transferFrom(msg.sender,
        0x000000000000000000000000000000000000dEaD, 
        config.publicluckyBurn*quantity);
    _safeMint(msg.sender, quantity);
    refundIfOver(publicPrice * quantity);
  }

  function refundIfOver(uint256 price) private {
    require(msg.value >= price, "Need to send more ETH.");
    if (msg.value > price) {
      payable(msg.sender).transfer(msg.value - price);
    }
  }

  function isPublicSaleOn(
    uint256 publicPriceWei,
    uint256 publicSaleStartTime
  ) public view returns (bool) {
    return
      publicPriceWei != 0 &&
      _isPublicSaleActive != false &&
      block.timestamp >= publicSaleStartTime;
  }

  function seedwhitelist(address[] memory addresses, uint256[] memory numSlots)
    external
    onlyOwner
  {
    require(
      addresses.length == numSlots.length,
      "addresses does not match numSlots length"
    );
    for (uint256 i = 0; i < addresses.length; i++) {
      whitelist[addresses[i]] = numSlots[i];
    }
  }

  function seedLucklist(address[] memory addresses, uint256[] memory numSlots)
    external
    onlyOwner
  {
    require(
      addresses.length == numSlots.length,
      "addresses does not match numSlots length"
    );
    for (uint256 i = 0; i < addresses.length; i++) {
      Lucklist[addresses[i]] = numSlots[i];
    }
  }

  // // metadata URI
  string private _baseTokenURI;

  function _baseURI() internal view virtual override returns (string memory) {
    return _baseTokenURI;
  }

  function setBaseURI(string calldata baseURI) external onlyOwner {
    _baseTokenURI = baseURI;
  }

  function withdrawMoney() external onlyOwner nonReentrant {
    (bool success, ) = msg.sender.call{value: address(this).balance}("");
    require(success, "Transfer failed.");
  }

  function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
    _setOwnersExplicit(quantity);
  }

  function numberMinted(address owner) public view returns (uint256) {
    return _numberMinted(owner);
  }

  function getOwnershipData(uint256 tokenId)
    external
    view
    returns (TokenOwnership memory)
  {
    return ownershipOf(tokenId);
  }
}