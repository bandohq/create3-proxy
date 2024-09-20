// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TestImplementation {
    uint256 public value;

    function initialize(uint256 _value) public {
        value = _value;
    }

    function setValue(uint256 _value) public {
        value = _value;
    }
}
