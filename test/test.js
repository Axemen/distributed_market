const Market = artifacts.require("Market");
const Store = artifacts.require("Store");

contract("Market", async (accounts) => {
  it("Should add a new store and set it's visibility according to what parameters are passed in", async () => {
    let market = await Market.deployed();

    let storeIPFS = "asdf";
    let visibility = true;

    await market.addStore(storeIPFS, visibility);
    let storeAddress = await market.stores(0);
    console.log(storeAddress);

    let store = new Store(storeAddress);

    assert.equal(await market.stores(0), storeAddress);
    assert.equal(await market.store_visibility(0), true); // Should default to true
    assert.equal(await store.is_visible(), visibility);
  });
});

contract("Market", async (accounts) => {
  it("Should return one store ipfs and one empty string", async () => {
    let market = await Market.deployed();
    await market.addStore("asdf", true);

    let r = await market.getStores([0, 1]);
    console.log("Get store results");

    assert.equal(
      JSON.stringify(["asdf", ""]),
      JSON.stringify(await market.getStores([0, 1]))
    );
  });
});
