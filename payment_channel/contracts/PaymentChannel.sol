// SPDX-License-Identifier: See License in License
pragma solidity ^0.8.3;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "./VerifySignature.sol";

contract PaymentChannel is Ownable{
    
    address payable public payee;
    uint256 public expiration;
    
    modifier ifExpired(){
        require(block.timestamp >= expiration, "Block is not yet expired");
        _;
    }
    
    constructor(address payable _payee, uint256 duration) payable{
        payee = _payee;
        expiration = block.timestamp + duration;
    }
    
    function extendExpiration(uint256 duration) public onlyOwner {
        expiration += duration;
    }
    
    function claimExpired() public onlyOwner ifExpired {
        selfdestruct(payable(owner()));
    }
    
    function close(uint256 amount, bytes memory signature, string memory message, uint nonceId) public {
        require(msg.sender == payee, "Requester is not a payee");
        VerifySignature verifiableSignature = new VerifySignature();
        
        // verifiableSignature.verify(owner(), msg.sender, amount, "", 0, signature);
        require(verifiableSignature.verify(owner(), msg.sender, amount, message, nonceId, signature), "Signature is not verified");
        
        payee.transfer(amount);
        selfdestruct(payable(owner()));
    }
}