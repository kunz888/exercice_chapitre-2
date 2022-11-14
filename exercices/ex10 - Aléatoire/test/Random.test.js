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
        'Random.sol': {
            content: fs.readFileSync("./exercices/ex10 - Aléatoire/sources/Random.sol", "utf-8")
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
const abi = contracts['Random.sol']['Random'].abi;
const bytecode = contracts['Random.sol']['Random'].evm.bytecode;

const getAccounts = async () => {
    return await web3.eth.getAccounts();
};

mocha.describe('Random', () => {




    
    mocha.it('It is a number!!!', async () => {
        const accounts = await getAccounts();
        const contract = await new web3.eth.Contract(abi)
            .deploy({ data: bytecode.object })
            .send({ from: accounts[0], gas: 2000000});

       
      
       const tx = await contract.methods.getRandom("hello").call({from:accounts[0]});
       console.log(tx);
       

     
    })
});