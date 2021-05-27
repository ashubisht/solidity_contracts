// SPDX-License-Identifier: See License in License
pragma solidity ^0.8.3;

contract VerifySignature {
    
    function getMsgHash(address to, uint amount, string memory message, uint nonce) public pure returns (bytes32){
        return keccak256(abi.encodePacked(to, amount, message, nonce));
    }
    
    function getPrefixedHash(bytes32 messageHash) public pure returns(bytes32){
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash));
    }
    
    function splitSign(bytes memory sign) public  pure returns(bytes32 r, bytes32 s, uint8 v){
        require(sign.length == 65, "Signature is invalid");
          assembly {
            r := mload(add(sign,32))
            s := mload(add(sign,64))
            v := byte(0, mload(add(sign, 96)))
        }
    }
    
    function recoverSigner(bytes32 prefixedHash, bytes memory sign) public pure returns(address){
        (bytes32 r, bytes32 s, uint8 v) = splitSign(sign);
        address addr = ecrecover(prefixedHash, v,r,s);
        return addr;
    }
    
    function verify(address signer, address to, uint amount, string memory message, uint nonce, bytes memory sign) public pure returns(bool){
        bytes32 messageHash = getMsgHash(to, amount, message, nonce);
        bytes32 prefixedHash = getPrefixedHash(messageHash);
        return recoverSigner(prefixedHash, sign) == signer; // Put signer here
        
    }
    
}