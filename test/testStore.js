const IPFS = require("ipfs-core");

const Market = artifacts.require("Market");
const Store = artifacts.require("Store");

contract("Market", async (_accounts) => {
  // Test the creation of a store in the market
  it("Should create a new store contract from the deployed market contract", async () => {
    let market = await Market.deployed();
    await market.addStore("asdf", true);
    let storeAddress = await market.stores(0);
    let store = new Store(storeAddress);

    assert.equal(await store.ipfsHash(), "asdf");
  });

  it("Should add an item", async () => {
    let market = await Market.deployed();
    await market.addStore("asdf", true);
    let storeAddress = await market.stores(0);
    let store = new Store(storeAddress);
    const ipfs = await IPFS.create();
    let item = {
      name: "Banana",
      description: "Long and yellow fruit.",
    };

    let cid = await ipfs.add(JSON.stringify(item));

    await store.addItem(cid["path"], true, 100, 10);
    let i = await store.items(0);

    assert.equal(i.ipfsHash, cid["path"]);
    await ipfs.stop();
  });
});

contract("Market", async (_accounts) => {
  // test store.getItems
  it("Should add new items and retrieve them", async () => {
    let market = await Market.deployed();
    await market.addStore("asdf", true);
    let storeAddress = await market.stores(0);
    let store = new Store(storeAddress);
    const ipfs = await IPFS.create();

    let itemOne = {
      name: "Banana",
      description: "Long and yellow fruit.",
    };
    let itemTwo = {
      name: "Kiwi",
      description: "Brown on the outside green on the inside.",
    };

    hashes = []

    let cid = await ipfs.add(JSON.stringify(itemOne));
    await store.addItem(cid['path'], true, 100, 10);
    hashes.push(cid['path']);

    cid = await ipfs.add(JSON.stringify(itemTwo));
    await store.addItem(cid['path'], true, 1000, 100);
    hashes.push(cid['path']);

    let values = await store.getItems([0, 1]);
    values = values.map(e => e[0]); // mapping out ipfsHashes

    assert.equal(JSON.stringify(values), JSON.stringify(hashes));
  });
});
