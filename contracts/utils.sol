// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


// library IdGenerator {
//     uint private n = 0;

//     function next()
// }

abstract contract IdGenerator {
    uint private n = 0;

    function next() public returns(uint) {
        uint r = n;
        n++;
        return r;
    }

    function current() public view returns(uint) {
        return n;
    }
}
