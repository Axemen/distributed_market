const { ethers } = require("ethers");
const fs = require("fs");

const provider = new ethers.providers.JsonRpcProvider("http://localhost:7545");
const signer = provider.getSigner();

const contract_address = "0x977510a612A56D3D0cBA2579EDc5D009412Bc74F";
const marketABI = JSON.parse(fs.readFileSync("build/contracts/Market.json"))[
  "abi"
];

async function main() {
  let marketContract = new ethers.Contract(
    contract_address,
    marketABI,
    provider
  );
  let marketSigner = marketContract.connect(signer);

  let storeIPFS = "asdf";
  let visibility = true;

  let owner = await signer.getAddress();

  filter = marketContract.filters.AddStore();
  marketContract.once(filter, (msgSender, storeId, storeAddress, event) => {
    console.log(event);
    console.log(msgSender, storeId, storeAddress);
  })


  let tx = await marketSigner.addStore(storeIPFS, visibility);
  // console.log(tx);
  
  await tx.wait(confirms=1);

  let x = await marketSigner.getStoreAddress(0);
  console.log(x);
}

main().then(() => process.exit());