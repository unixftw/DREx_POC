// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DRExToken is ERC20 {
    IERC20 private _token;

    constructor(uint256 initialSupply) ERC20("DREx", "DRX") {
        _mint(msg.sender, initialSupply);
    }

    function setAddress(IERC20 token) external {
        _token = token;
    }

    function tranferingfunds(address payable to, uint256 amt) external {
        _token.transfer(to, amt);
    }
}
