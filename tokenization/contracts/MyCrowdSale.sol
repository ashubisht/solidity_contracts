// SPDX-License-Identifier: MIT
pragma solidity >=0.8.3 <0.9.0;

import "./Crowdsale.sol";

contract MyCrowdSale is Crowdsale {
    constructor (uint256 rate, address payable wallet, IERC20 token) Crowdsale(rate, wallet, token){
        
    }
}