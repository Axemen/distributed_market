// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./access.sol";
import "./utils.sol";

contract Marketplace is Access {

    struct Store {
        address owner;
        string ipfs_hash;
        bool is_visible;
        uint256[] item_ids;
    }

    struct Item {
        string ipfs_hash;
        bool is_visible;
    }

    IdGenerator store_id_generator = new IdGenerator();
    IdGenerator item_id_generator = new IdGenerator();

    mapping(uint256 => Store) public stores;
    mapping(uint256 => Item) public items;

    function addStore(
        address store_owner,
        string memory ipfs_hash,
        bool is_visible
    ) external {
        uint256[] memory item_ids;
        Store memory new_store = Store({
            owner: store_owner,
            ipfs_hash: ipfs_hash,
            is_visible: is_visible,
            item_ids: item_ids
        });
        stores[store_id_generator.next()] = new_store;
    }

    function removeStore(uint256 store_id) external requiresAdmin() {
        delete stores[store_id];
    }

    function getStore(uint256 store_id) external view returns (string memory) {
        return stores[store_id].ipfs_hash;
    }

    function getStores(uint256[] calldata ids)
        external
        view
        returns (string[] memory)
    {
        string[] memory results = new string[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            results[i] = stores[ids[i]].ipfs_hash;
        }
        return results;
    }

    function getAllStores(uint256 cursor, uint256 length)
        external
        view
        returns (uint256, string[] memory)
    {
        uint256 c = 0;
        string[] memory values = new string[](length);
        for (uint256 i = cursor; (c < length && cursor < store_ids); i++) {
            if (stores[cursor].is_visible) values[c] = stores[cursor].ipfs_hash;
            cursor++;
        }
        return (cursor, values);
    }

    function addItem(uint store_id, string memory ipfs_hash, bool is_visible) external {
        Item memory new_item = Item({
            ipfs_hash: ipfs_hash,
            is_visible: is_visible
        });

        items[item_id_generator.next()] = new_item;
        stores[store_id].item_ids.push(item_id_generator.current());
    }

    function getItem(uint256 item_id) external view returns (string memory) {
        return items[item_id].ipfs_hash;
    }

    function getItems(uint256[] calldata item_ids)
        external
        view
        returns (string[] memory)
    {
        string[] memory values = new string[](item_ids.length);
        for (uint256 i = 0; i < item_ids.length; i++) {
            values[i] = items[item_ids[i]].ipfs_hash;
        }
        return values;
    }

    function getItemsFromStore(
        uint256 store_id,
        uint256 cursor,
        uint8 length
    ) external view returns (string[] memory values, uint256) {
        Store memory s = stores[store_id];
        values = new string[](length);
        uint8 c = 0;
        for (cursor; cursor < s.item_ids.length; cursor++) {
            if (c == length) {
                return (values, cursor);
            }
            uint256 item_id = s.item_ids[cursor];
            if (items[item_id].is_visible) {
                values[c] = items[item_id].ipfs_hash;
                c++;
            }
        }
        return (values, cursor);
    }
}
