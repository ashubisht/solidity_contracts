// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.3;

contract Ownable {
    address payable _owner;
    
    constructor() {
        _owner = payable(msg.sender);
    }

   
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

   
}