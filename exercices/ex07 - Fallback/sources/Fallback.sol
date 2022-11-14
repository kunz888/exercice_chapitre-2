// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Fallback{
 
 event Log(string func,address sender,uint value,bytes data);

  uint public countr ;
  uint public countf ;

 // Function to receive Ether. msg.data must be empty
      receive() external payable {
        emit Log("receive",msg.sender,msg.value,"");
        countr++;
    }

    // Fallback function is called when msg.data is not empty
    fallback() external payable {
        emit Log("fallback",msg.sender,msg.value,msg.data);
         countf++;
    }
}