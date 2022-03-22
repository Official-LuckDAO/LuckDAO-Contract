// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";  

/// @custom:security-contact niuza001@gmail.com
contract Mooney is ERC20{
    constructor() ERC20("Mooney", "MooneyX") {
        _mint(msg.sender, 10000000000 * 10 ** decimals());
    }
}