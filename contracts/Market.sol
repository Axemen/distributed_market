// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Access.sol";
import "./Utils.sol";
import "./Store.sol";

contract Market is Access {
    using IdGenerators for IdGenerators.IdGenerator;

    IdGenerators.IdGenerator storeIdGenerator;
    mapping(uint256 => Store) public stores;
    mapping(uint256 => bool) storeVisibility;

    struct Result {
        string ipfsHash;
        address storeAddress;
    }

    event AddStore(address indexed msgSender, uint storeId, address storeAddress);

    constructor() Access(msg.sender){}

    function addStore(string memory ipfsHash, bool isVisible) 
    external {
        Store s = new Store(msg.sender, ipfsHash, isVisible);
        uint storeId = storeIdGenerator.next();

        stores[storeId] = s;
        storeVisibility[storeId] = true;

        emit AddStore(msg.sender, storeId, address(s));
    }

    function setStoreVisibility(uint256 storeId, bool isVisible) 
    external requiresAdmin() {
        storeVisibility[storeId] = isVisible;
    }

    function getStore(uint storeId) 
    external view returns(Result memory) {
        Store s = stores[storeId];

        if (storeVisibility[storeId]) {
            return Result({
                ipfsHash: s.ipfs_hash(),
                storeAddress: address(s)
            });
        } 
        return Result();
    }

    function getStores(uint256[] calldata ids)
    external view returns (string[] memory) {
        string[] memory results = new string[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            if (address(stores[ids[i]]) != address(0)) {
                results[i] = stores[ids[i]].ipfs_hash();
            }
        }
        return results;
    }

    function getAllStores(uint256 cursor, uint256 length)
    external view returns (uint256, string[] memory) {
        uint256 c = 0;
        string[] memory values = new string[](length);
        for (uint256 i = cursor; (c < length && cursor <= store_id_generator.current()); i++) {
            if (store_visibility[cursor] &&  stores[cursor].is_visible()) values[c] = stores[cursor].ipfs_hash();
            cursor++;
            c++;
        }
        return (cursor, values);
    }
}
