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

    function getStoreVisibility(uint storeId) 
    external view requiresAdmin() returns(bool) {
        return storeVisibility[storeId];
    }

    function getStore(uint storeId) 
    external view returns(Result memory) {
        Store s = stores[storeId];

        require(storeId <= storeIdGenerator.current(), "This store does not exist");
        require(address(s) != address(0), "This store does not exist");
        require(s.isVisible(), "This store does not exist");

        return Result({
            ipfsHash: s.ipfsHash(),
            storeAddress: address(s)
        });
    }

    function getStores(uint256[] calldata ids)
    external view returns (Result[] memory) {
        Result[] memory results = new Result[](ids.length);

        for (uint256 i = 0; i < ids.length; i++) {
            if (address(stores[ids[i]]) != address(0)) {
                Store s = stores[ids[i]];
                results[i] = Result({
                    ipfsHash: s.ipfsHash(),
                    storeAddress: address(s)
                });
            }
        }
        return results;
    }

    function getAllStores(uint256 cursor, uint256 length)
    external view returns (uint256, Result[] memory) {
        uint256 c = 0;
        Result[] memory values = new Result[](length);
        for (cursor; (c < length && cursor <= storeIdGenerator.current()); cursor++) {
            if (storeVisibility[cursor] &&  stores[cursor].isVisible()) {
                Store s = stores[cursor];
                values[c] = Result({
                    ipfsHash: s.ipfsHash(),
                    storeAddress: address(s)
                });
                c++;
            }
            cursor++;
        }
        return (cursor, values);
    }
}
