// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
 
import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; 
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ERC721A.sol";

/// @custom:security-contact niuza001@gmail.com
contract LuckyAirdrop is Ownable{ 
    address public luckyAddr;//=0x2B06Ba516A1Ee8286C549F9D49Cd1B013f31549C; 
    address public metaNFTAddr;//(0xCaD0A96b3B0fda25bA9C069913CA456833598a4E); 
    uint public nFTdrop=5000*10**18;
    uint public desAddrDrop=500*10**18;

    constructor(address _luckyAddr,address  _metaNFTAddr)  { 
        luckyAddr=_luckyAddr;
        metaNFTAddr=_metaNFTAddr;
    }
    receive() external payable{}

    mapping (uint => bool) internal claimed;
    function checkclaimed(uint256 nftID) public view returns (bool thisclaimed){
        thisclaimed=claimed[nftID];  
    }
  
    function setdropNum(uint _nFTdrop,uint _desAddrDrop) public onlyOwner{
        if (_nFTdrop>0)nFTdrop=_nFTdrop;
        if (_desAddrDrop>0)desAddrDrop=_desAddrDrop;
        }

    function NFTAirDropClaim() public{        
        bool claimable=false;
        ERC721A LuckMetaNFT=ERC721A(metaNFTAddr); 
        uint yourBalance=LuckMetaNFT.balanceOf(msg.sender);
        uint claimableBalance=0;
        for (uint i = 0; i < yourBalance; i++) {
            uint thisNFT_ID=LuckMetaNFT.tokenOfOwnerByIndex(msg.sender,i);
            if (claimed[thisNFT_ID]==false){
                claimed[thisNFT_ID]=true;
                claimableBalance=claimableBalance+1;
                claimable=true;
            }
        }        
        require(claimable==true,"NFTs claimed");
        safeTransfer(msg.sender,nFTdrop*claimableBalance);
    }



    function LuckeyAirdrop(address[] memory dests) onlyOwner public
        returns (uint256) {
        uint256 i = 0;
        while (i < dests.length) {
            safeTransfer(dests[i],desAddrDrop); 
            i += 1;
        }
        return(i);
    }

    function safeTransfer(        
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes("transfer(address,uint256)")));
        (bool success, bytes memory data) = luckyAddr.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper::safeTransfer: transfer failed"
        );
    }

    function DrawBack( 
        uint256 amount 
    ) public onlyOwner{  
        safeTransfer(msg.sender, amount);
    }
}