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
    bool visible;
  }
  uint private listings_id = 0; // initialize at zero and increment as mapping grows
  mapping(uint => Listing) private listings;


  modifier restricted() {
    require(msg.sender == owner, "This function is restricted to the contract's owner");
    _;
  }

  modifier requiresOwnerOfItem(uint listing_id) {
    require(msg.sender == owner || msg.sender == listings[listing_id].owner, "You do not have permission to unlist this item");
    _;
  }

  function unlistItem(uint listing_id) public {
    listings[listing_id].visible = false;
    listings[listing_id].stock = 0;
    emit UpdateListing(msg.sender, listing_id, "unlist");
  }

  function increaseStockOfItem(uint listing_id, uint amount) public 
  requiresOwnerOfItem(listing_id) {
    listings[listing_id].stock += amount;
    emit UpdateListing(msg.sender, listing_id, "iStock");
  }
 
  function setItemVisibility(uint listing_id, bool value) public 
  requiresOwnerOfItem(listing_id) {
    listings[listing_id].visible = value;
    if (value) {
      emit UpdateListing(msg.sender, listing_id, "visable");
    } else {
      emit UpdateListing(msg.sender, listing_id, "invisible");
    }
  }

  function updateItem(uint listing_id, bool is_visible, string memory ipfs_hash, uint stock) public requiresOwnerOfItem(listing_id){
    listings[listings_id] = Listing({
      ipfs_hash: ipfs_hash,
      owner: msg.sender,
      stock: stock,
      visible: is_visible
    });
    emit UpdateListing(msg.sender, listings_id, "update");
  }

  function listItem(string memory ipfs_hash, uint stock, bool is_visible) public {
    listings[listings_id] = Listing({
      ipfs_hash: ipfs_hash,
      owner: msg.sender,
      stock: stock,
      visible: is_visible
    });
    emit UpdateListing(msg.sender, listings_id, "add");
    listings_id++;
  }

  function getListing(uint listing_id) public view 
  returns(string memory ipfs_hash, address listing_owner, uint stock, bool is_visible) {
    Listing memory listing = listings[listing_id]; 
    return (listing.ipfs_hash, listing.owner, listing.stock, listing.visible);
  }

  
}
