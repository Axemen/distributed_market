// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Marketplace {
  address public owner = msg.sender;

  // UpdateListing(address owner, string ipfs_hash, bytes10 update_type)
  event UpdateListing(address, uint, bytes10);
  
  struct Listing {
    string ipfs_hash;
    address owner;
    uint stock;
  }
  uint private listings_id = 0; // initialize at zero and increment as mapping grows
  mapping(uint => Listing) public listings;
  // mapping(address => mapping(uint => Listing)) public users;


  modifier restricted() {
    require(
      msg.sender == owner,
      "This function is restricted to the contract's owner"
    );
    _;
  }

  function removeListing(uint listing_id) public {}

  function addListing(string memory ipfs_hash, uint stock) public {
    listings[listings_id] = Listing({
      ipfs_hash: ipfs_hash,
      owner: msg.sender,
      stock: stock
    });
    emit UpdateListing(msg.sender, listings_id, "add");
    listings_id++;
  }

  // Solidity should automatically create the getter function for the public mapping
  // function getListing(uint listing_id) public view returns(string memory, address) {
  //   Listing memory listing = listings[listing_id]; 
  //   return (listing.ipfs_hash, listing.owner);
  // }
}
