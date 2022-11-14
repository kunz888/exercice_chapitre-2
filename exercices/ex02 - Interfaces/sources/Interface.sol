// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;
contract Counter {
    uint public count;

    function increment() external {
        count += 1;
    }
    function reset() external {
        count = 0;
    }
      function setCount() external {
        count = count;
    }
}

interface ICounter {
    function getValue() external view returns (uint);
    function increment() external;
    function reset() external;
    function setCount() external;
    
}


