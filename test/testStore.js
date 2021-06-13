const IPFS = require("ipfs-core");

const Market = artifacts.require("Market");
const Store = artifacts.require("Store");


contract("Market", async (accounts) => {
    // Test the creation of a store in the market
    it("Should create a new store contract from the deployed market contract", async () => {
        let market = await Market.deployed();
        await market.addStore("asdf", true);
        let storeAddress = await market.stores(0);
        let store = new Store(storeAddress);
        assert.equal(await store.ipfs_hash(), 'asdf');
    });
});