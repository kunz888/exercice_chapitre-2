// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Payable{

event Transaction(address  _to,uint _amountTransactions);
     // Permet de recevoir une quantite d'ether a la creation de mon contract

    constructor() payable {
        
    }


    function sendTo() external payable{
//solde courant  du contrat
  
    bool sent= payable(msg.sender).send(address(this).balance);   
    require(sent, "send failed");
    emit Transaction(msg.sender,address(this).balance);
     
    }

  
}