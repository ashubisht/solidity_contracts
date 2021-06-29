// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.3;

import "./ItemManager.sol";

// Take and handle payment
contract Item {
    uint public priceInWei;
    uint public pricePaid;
    uint public index;
    
    ItemManager public parentContract;
    
    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract; // new parentContract() not work due to circular dependency. This is reference therefore will not throw circular deoendency error
    }
    
    
    receive() external payable {
        require(pricePaid == 0, "Price is paid already");
        require(priceInWei == msg.value, "Only full payments allowed");
        pricePaid += msg.value;
        // address(parentContract).transfer(msg.value); //limited gas
        (bool success, ) = address(parentContract).call{value: msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "Transaction wasnt successful, so cancelling");
        
    }
    
    fallback() external {
        
    }
    
}