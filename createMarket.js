const { ethers } = require("ethers");
const fs = require("fs");
const IPFS = require("ipfs-core");
const provider = new ethers.providers.JsonRpcProvider("http://localhost:7545");
const signer = provider.getSigner();

const contract_address = "0x8E3dF9801b671bF7FCD21BE329F7863d8592d4C8";

async function main() {
  const ipfs = await IPFS.create();
  const marketABI = JSON.parse(
    fs.readFileSync("build/contracts/Market.json")
  )["abi"];

  const market = new ethers.Contract(contract_address, marketABI, provider);
  const marketSigner = market.connect(signer);

  

  for (let i = 0; i < 50; i++) {
    let m = {
      title: `store ${i}`,
      description: `This is store ${i}`
    }

    // add to ipfs
    let cid = await ipfs.add(JSON.stringify(m));

    // add to blockchain
    await marketSigner.addStore(cid["path"], true);
    console.log(i);
  }
}
main().then(() => process.exit());
