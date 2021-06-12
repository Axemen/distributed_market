// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./access.sol";
import "./utils.sol";
import "./store.sol";

contract Marketplace is Access {
    using IdGenerators for IdGenerators.IdGenerator;

    IdGenerators.IdGenerator store_id_generator;
    mapping(uint256 => Store) public stores;
    mapping(uint256 => bool) public store_visibility;

    constructor() Access(msg.sender){}

    function addStore(string memory ipfs_hash, bool is_visible) 
    external returns(address){
        stores[store_id_generator.next()] = new Store(msg.sender, ipfs_hash, is_visible);
        store_visibility[store_id_generator.current()] = true;
        return address(stores[store_id_generator.current()]);
    }

    function setStoreVisibility(uint256 store_id, bool visible) 
    external requiresAdmin() {
        store_visibility[store_id] = visible;
    }

    function getStore(uint256 store_id) 
    external view returns (string memory) {
        return stores[store_id].ipfs_hash();
    }

    function getStores(uint256[] calldata ids)
    external view returns (string[] memory) {
        string[] memory results = new string[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            results[i] = stores[ids[i]].ipfs_hash();
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
        }
        return (cursor, values);
    }
}
