const ItemManager = artifacts.require("./ItemManager.sol");

// All accounts present in next line, therefore its accounts array
contract("ItemManager", (accounts) => {
  it("... should be able to add an items", async () => {
    const itemManagerInstance = await ItemManager.deployed();
    const itemName = "Toy car";
    const itemPrice = 500;

    const result = await itemManagerInstance.createItem(itemName, itemPrice, {
      from: accounts[0],
    });
    assert.equal(result.logs[0].args._itemIndex, 0, "It is not the first time");

    const item = await itemManagerInstance.items(0);
    assert.equal(item._id, itemName, "The identifier is different");
  });
});
