const { ethers } = require("ethers");
const fs = require("fs");
const IPFS = require("ipfs-core");
const provider = new ethers.providers.JsonRpcProvider("http://localhost:7545");
const signer = provider.getSigner();

const contract_address = "0xF55E0bcFCf57456D6EE353fBF518fF27D0c6D4b1";
const owner = "0x18687676341a21D549e09d7CF054CaC6f6c2AE64";

async function main() {
  const ipfs = await IPFS.create();
  
  const marketABI = JSON.parse(
    fs.readFileSync("build/contracts/Marketplace.json")
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
    let a = await marketSigner.addStore(cid['path'], true);
    console.log(a);
  }
}
main().then(() => process.exit());
