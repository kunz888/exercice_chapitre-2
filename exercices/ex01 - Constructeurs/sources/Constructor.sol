// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Constructor {
    uint public a;

    constructor(uint a_) {
        a = a_;
    }
}