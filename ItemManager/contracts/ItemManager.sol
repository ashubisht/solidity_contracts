// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.3;

import "./Item.sol";
import "./Ownable.sol";

contract ItemManager is Ownable {
    
    enum SupplyChainState {
        CREATED, PAID, DELIVERED
    }
    
    mapping(uint => S_Item) public items;
    uint itemIndex;
    
    struct S_Item {
        Item _item;
        string _id;
        uint _itemPrice;
        SupplyChainState _state;
    }
    
    event SupplyChainStep(uint _itemIndex, uint _itemPrice, address _itemAddress);
    
    
    function createItem(string memory _id, uint _itemPrice) public onlyOwner{
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._id = _id;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.CREATED;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(item));
        itemIndex++;
    }
    
    function triggerPayment(uint _itemindex) public payable{
        require(items[_itemindex]._itemPrice ==msg.value, "Please check the payment value");
        require(items[_itemindex]._state == SupplyChainState.CREATED, "Item is not in the chain");
        items[_itemindex]._state = SupplyChainState.PAID;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(items[_itemindex]._item));

    }
    
    function triggerDelivery(uint _itemindex) public onlyOwner{
        require(items[_itemindex]._state == SupplyChainState.PAID, "Payment for the item is not yet done");
        items[_itemindex]._state = SupplyChainState.DELIVERED;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(items[_itemindex]._item));

    }
}