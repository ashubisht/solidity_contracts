// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.3;

contract Owned {
  address payable owner;

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }

  constructor() {
    owner = payable(msg.sender); // Should typecast implicitly but vscode solhint, thankyou! -_-
  }

}