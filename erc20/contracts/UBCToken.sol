//SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.3;

contract UBCToken{

  address owner;

  string public name;
  string public symbol;
  uint public totalSupply;
  uint8 public decimals;

  mapping(address => uint) public balanceOf;
  mapping(address => mapping(address => uint)) public allowance;

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);

  constructor(string memory _name, string memory _symbol, uint _totalSupply, uint8 _decimals){
    name = _name;
    symbol = _symbol;
    totalSupply = _totalSupply;
    decimals = _decimals;
    owner = msg.sender;
    balanceOf[msg.sender] = _totalSupply;
  }

  function transfer(address _to, uint256 _value) public returns (bool success){
    require(msg.sender.balance >= _value, "You dont have sufficient funds to process this transaction");
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _value) public returns (bool success){
    allowance[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
    require(_value <= balanceOf[_from], "Insufficient funds to process the transaction");
    require(_value <= allowance[_from][msg.sender], "The funds to transfer is greater than the approved limit");
    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    emit Transfer(_from, _to, _value);
    return true;
  }


}