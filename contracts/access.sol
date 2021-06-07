// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

abstract contract Access {
    mapping(address => bool) admins;

    function isAdmin(address a) internal view returns (bool) {
        return admins[a];
    }

    function isSenderAdmin() internal view returns (bool) {
        return admins[msg.sender];
    }

    modifier requiresAdmin() {
        require(
            admins[msg.sender],
            "You need admin access to use this function"
        );
        _;
    }
}
