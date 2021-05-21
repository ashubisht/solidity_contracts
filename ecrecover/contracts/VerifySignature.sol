// SPDX-License-Identifier: See License in License
pragma solidity ^0.8.3;

contract VerifySignature {
    
    function getMessageHash(address to, uint amount, string memory message, uint nonce) public pure returns (bytes32){
        return keccak256(abi.encodePacked(to, amount, message, nonce));
    }
    
    function getEthSignedMsgHash(bytes32 messageHash) public pure returns(bytes32){
        return keccak256(abi.encodePacked("\x19EthereumSignedMessage:\n32", messageHash));
    }
    
    function splitSign(bytes memory sign) public  pure returns(bytes32 r, bytes32 s, uint8 v){
        require(sign.length == 65, "Signature is invalid");
        assembly {
            r := mload(add(sign,32))
            s := mload(add(sign,64))
            v := byte(0, mload(add(sign, 96)))
        }
    }
    
    function recoverSigner(bytes32 ethMsgHash, bytes memory sign) public pure returns(address){
        (bytes32 r, bytes32 s, uint8 v) = splitSign(sign);
        return ecrecover(ethMsgHash, v,r,s);
    }
    
    function verify(address signer, address to, uint amount, string memory message, uint nonce, bytes memory sign) public pure returns(bool){
        
        bytes32 messageHash = getMessageHash(to, amount, message, nonce);
        bytes32 signedEthMsgHash = getEthSignedMsgHash(messageHash);
        return recoverSigner(signedEthMsgHash, sign) == signer;
        
    }
    
    
}