// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;
 contract Modifier{ 

  address public owner;

  modifier isOwner {
    require(msg.sender == owner, "Ownable: You are not the owner, Bye.");
    _;
  }

  constructor () public {
    owner = msg.sender;
  }
 function VerifOwner() public view isOwner returns(bool) {
   // code in onlyOwner will execute first
   // and only if require check passes will this code below run
bool b=true;
   return b;
}
}