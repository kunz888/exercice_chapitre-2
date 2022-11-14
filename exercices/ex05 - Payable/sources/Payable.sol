// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Payable{


     // Permet de recevoir une quantite d'ether a la creation de mon contract

    constructor() payable {
        require(msg.value>=2,"Vous devez envoyer plus de wei");
    }

    
}