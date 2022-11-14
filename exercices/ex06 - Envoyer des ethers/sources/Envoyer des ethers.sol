// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Payable{


     // Permet de recevoir une quantite d'ether a la creation de mon contract

    constructor() payable {
        
    }


    function sendTo() external payable{

     payable(msg.sender).transfer(address(this).balance);   
    }

    
}