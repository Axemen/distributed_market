// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

library IdGenerators {
    struct IdGenerator {
        uint value;
    }

    function next(IdGenerator storage self) public returns(uint) {
        uint c = self.value;
        self.value++;
        return c;
    }

    function current(IdGenerator storage self) public view returns(uint) {
        return self.value;
    }
}