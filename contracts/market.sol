// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Access.sol";
import "./Utils.sol";
import "./Store.sol";

contract Market is Access {
    using IdGenerators for IdGenerators.IdGenerator;

    IdGenerators.IdGenerator store_id_generator;
    mapping(uint256 => Store) public stores;
    mapping(uint256 => bool) public store_visibility;

    struct Result {
        string ipfs_hash;
        address store_address;
    }

    event AddStore(address indexed msgSender, uint storeId, address storeAddress);

    constructor() Access(msg.sender){}

    function addStore(string memory ipfs_hash, bool is_visible) 
    external {
        Store s = new Store(msg.sender, ipfs_hash, is_visible);
        uint storeId = store_id_generator.next();

        stores[storeId] = s;
        store_visibility[storeId] = true;

        emit AddStore(msg.sender, storeId, address(s));
    }

    function setStoreVisibility(uint256 store_id, bool visible) 
    external requiresAdmin() {
        store_visibility[store_id] = visible;
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
        }
        return (cursor, values);
    }
}
