// SPDX-License-Identifier: MIT
pragma solidity >=0.8 <0.9.0;

abstract contract Access {
    mapping(address => bool) admins;
    address owner;

    constructor(address _owner){
        owner = _owner;
        admins[owner] = true;
    }

    function addAdmin(address a) public {
        admins[a] = true;
    }

    function isAdmin(address a) public view returns (bool) {
        return admins[a];
    }

    modifier requiresAdmin() {
        require(
            admins[msg.sender],
            "You need admin access to use this function"
        );
        _;
    }

    modifier requiresOwner() {
        require(msg.sender == owner);
        _;
    }

    function isOwner(address a) public view returns(bool) {
        return a == owner;
    }

}
