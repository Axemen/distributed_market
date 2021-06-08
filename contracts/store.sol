// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./utils.sol";
import "./access.sol";


contract Store is Access {
    using IdGenerators for IdGenerators.IdGenerator;

    struct Item {
        string ipfs_hash;
        bool is_visible;
        uint price;
        uint stock;
    }

    string public ipfs_hash;
    bool public is_visible;

    IdGenerators.IdGenerator item_id_generator;
    mapping(uint => Item) public items; // item_id => ItemInfo

    constructor(address _owner, string memory _ipfs_hash, bool _is_visible) 
    Access(_owner) {
        owner = _owner;
        ipfs_hash = _ipfs_hash;
        is_visible = _is_visible;
    }

    function addItem(string memory item_ipfs_hash, bool item_is_visible, uint price, uint stock) external {
        items[item_id_generator.next()] = Item({
            ipfs_hash: item_ipfs_hash,
            is_visible: item_is_visible,
            price: price,
            stock: stock
        });
    }

    function getItem(uint item_id) external view returns(string memory) {
        return items[item_id].ipfs_hash;
    }

    function getItems(uint256[] calldata item_ids)
    external view returns (string[] memory) {
        string[] memory values = new string[](item_ids.length);
        for (uint256 i = 0; i < item_ids.length; i++) {
            values[i] = items[item_ids[i]].ipfs_hash;
        }
        return values;
    }

    function iterateItems(uint256 cursor, uint8 length) 
    external view returns (string[] memory values, uint256) {
        values = new string[](length);
        uint8 c = 0;
        for (cursor; cursor < item_id_generator.current(); cursor++) {
            if (c == length) {
                return (values, cursor);
            }
            if (items[cursor].is_visible) {
                values[c] = items[cursor].ipfs_hash;
                c++;
            }
        }
        return (values, cursor);
    }

    function purchaseItem(uint item_id, uint number_to_buy) 
    external payable{
        require(items[item_id].stock > 0, "This item is no longer in stock");
        require((items[item_id].stock - number_to_buy) > 0, "This item does not have enough stock");
        require(msg.value == (items[item_id].price * number_to_buy), "Incorrect value sent with transaction");

        // reduce the stock by the number to buy
        items[item_id].stock -= number_to_buy;
    }
}