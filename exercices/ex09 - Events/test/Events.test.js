const ganache = require('ganache-cli');
const provider = ganache.provider();
const Web3 = require('web3');
const web3 = new Web3(provider);
const solc = require('solc');
const fs = require("fs");
const assert = require('assert');
const mocha = require('mocha');

const input = {
    language: 'Solidity',
    sources: {
        'Events.sol': {
            content: fs.readFileSync("./exercices/ex09 - Events/sources/Events.sol", "utf-8")
        }
    },
    settings: {
        outputSelection: {
            '*': {
                '*': ['*']
            }
        }
    }
};
const { contracts } = JSON.parse(solc.compile(JSON.stringify(input)));
const abi = contracts['Events.sol']['Payable'].abi;
const bytecode = contracts['Events.sol']['Payable'].evm.bytecode;

const getAccounts = async () => {
    return await web3.eth.getAccounts();
};

mocha.describe('Events', () => {

    mocha.it('Has been deployed', async () => {
        try {
            const accounts = await getAccounts();
            const contract = await new web3.eth.Contract(abi)
                .deploy({ data: bytecode.object })
                .send({ from: accounts[0], gas: 2000000,value:web3.utils.toWei("2","ether")});

            assert.ok(contract.options.address);

        } catch (e) {
            console.error(e);
        }
    })


    
    mocha.it('We have destroy and send money', async () => {
        const accounts = await getAccounts();
        const contract = await new web3.eth.Contract(abi)
            .deploy({ data: bytecode.object })
            .send({ from: accounts[0], gas: 2000000,value:web3.utils.toWei("2","ether")});

       
       
        let balanceContractBeforeSend = await web3.eth.getBalance(contract.options.address);
        console.log("contrat",balanceContractBeforeSend);
        let balanceReceiveBeforeSend = await web3.eth.getBalance(accounts[0]);
        console.log("compte receveur",balanceReceiveBeforeSend);
       
       const tx = await contract.methods.sendTo().send({from:accounts[0]});
       console.log(tx);
       console.log(`Message: ${tx.gasUsed}`);

        let balanceContractAfterSend = await web3.eth.getBalance(contract.options.address);
        console.log("contrat",balanceContractAfterSend);
        let balanceReceiveAfterSend = await web3.eth.getBalance(accounts[0]);
        console.log("compte receveur",balanceReceiveAfterSend);

     
    })
});