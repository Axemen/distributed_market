const IPFS = require("ipfs-core");

const Market = artifacts.require("Market");
const Store = artifacts.require("Store");


// Test Market.addStore
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

// Test Market.getStores
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

async function getAllStores(start, page_size) {
  let hasMore = true
  let allValues = []
  while (hasMore) {
    let cursor = 
    let cursor, values = market.getAllStores()
  }
}

// Test Market.getAllStores
contract("Market", async (accounts) => {
  it("Should iterate through all available stores", async () => {
    const market = await Market.deployed();
    const ipfs = await IPFS.create();

    let hashes = []
    for (let i = 0; i < 20; i++) {
      let m = {
        title: `store ${i}`,
        description: `This is store ${i}`
      }

      let cid = await ipfs.add(JSON.stringify(m));
      hashes.push(cid);
      await market.addStore(cid['path'], true);
    }

    let cursor = 0;
    let {cursor, values} = await market.getAllStores(cursor, 10);
    
  })
});