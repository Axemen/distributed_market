const { ethers } = require("ethers");
const fs = require("fs");
const IPFS = require("ipfs-core");
const provider = new ethers.providers.JsonRpcProvider("http://localhost:7545");
const signer = provider.getSigner();

const contract_address = "0x5D4410C1280e4F6050b081D51E560a18f14af814";

async function main() {
  const ipfs = await IPFS.create();
  const marketABI = JSON.parse(
    fs.readFileSync("build/contracts/Market.json")
  )["abi"];

  const market = new ethers.Contract(contract_address, marketABI, provider);
  const marketSigner = market.connect(signer);

  let markets = [
    {
      title: "store 0",
      description: "This is store 0!",
    },
    {
      title: "store 1",
      description: "this is store 1",
    },
    {
      title: "Store 2",
      description: "this is store 2",
    },
    {
      title: "Store 3",
      description: "This is store 3",
    },
  ];

  for (let i = 0; i < markets.length; i++) {
    let element = markets[i];

    // add to ipfs
    let cid = await ipfs.add(JSON.stringify(element));

    // add to blockchain
    let a = await marketSigner.addStore(cid["path"], true);
    console.log(a);
  }
}
main().then(() => process.exit());
