// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Random{

    function getNumber(string memory _str) public pure returns (uint256){
      uint256 nb;  
      bytes32 strHash=hash(_str);
      nb=uint256(bytes32(strHash));
      return nb;
    }  
//fonction de hashage
    function hash(string memory _string) public pure returns(bytes32) {
     return keccak256(abi.encodePacked(_string));

   }   
  function getRandom(string memory _str) public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender,_str)));
    }
}