// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Utils.sol";
import "./Access.sol";


contract Store is Access {
    using IdGenerators for IdGenerators.IdGenerator;

    struct Item {
        string ipfsHash;
        bool isVisible;
        uint price;
        uint stock;
    }

    string public ipfsHash;
    bool public isVisible;

    IdGenerators.IdGenerator itemIdGenerator;
    mapping(uint => Item) public items; // item_id => ItemInfo

    constructor(address _owner, string memory _ipfsHash, bool _isVisible) 
    Access(_owner) {
        owner = _owner;
        ipfsHash = _ipfsHash;
        isVisible = _isVisible;
    }

    function addItem(string memory item_ipfs_hash, bool item_is_visible, uint price, uint stock) external {
        items[itemIdGenerator.next()] = Item({
            ipfsHash: item_ipfs_hash,
            isVisible: item_is_visible,
            price: price,
            stock: stock
        });
    }

    function getItems(uint256[] calldata item_ids)
    external view returns (string[] memory) {
        string[] memory values = new string[](item_ids.length);
        for (uint256 i = 0; i < item_ids.length; i++) {
            values[i] = items[item_ids[i]].ipfsHash;
        }
        return values;
    }

    function getAllItems(uint256 cursor, uint length) 
    external view returns (uint, Item[] memory) {
        Item[] memory values = new Item[](length);
        uint c = 0;
        
        for (cursor; (c < length && cursor <= itemIdGenerator.current()); cursor++) {
            if (items[cursor].isVisible) {
                values[c] = items[cursor];
                c++;
            }
        }
        return (cursor, values);
    }

    function purchaseItem(uint itemId, uint numberToBuy) 
    external payable{
        require(items[itemId].stock > 0, "This item is no longer in stock");
        require((items[itemId].stock - numberToBuy) > 0, "This item does not have enough stock");
        require(msg.value == (items[itemId].price * numberToBuy), "Incorrect value sent with transaction");

        // reduce the stock by the number to buy
        items[itemId].stock -= numberToBuy;
    }
}