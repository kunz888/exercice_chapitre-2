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
        'Fallback.sol': {
            content: fs.readFileSync("./exercices/ex07 - Fallback/sources/Fallback.sol", "utf-8")
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
const abi = contracts['Fallback.sol']['Fallback'].abi;
const bytecode = contracts['Fallback.sol']['Fallback'].evm.bytecode;

const getAccounts = async () => {
    return await web3.eth.getAccounts();
};

mocha.describe('Fallback', () => {

    mocha.it('Has been deployed', async () => {
        try {
            const accounts = await getAccounts();
            const contract = await new web3.eth.Contract(abi)
                .deploy({ data: bytecode.object })
                .send({ from: accounts[0], gas: 1000000 });
    
           // console.log(await contract.methods.fallback().call());
    
            try {
              const tx=  await web3.eth.sendTransaction({from: accounts[0], to: contract.options.address, data: null})
              console.log(tx);
            }
            catch {
                console.log("function not find...")
            }
    
    
            //console.log(await contract.methods.state().call());
        } catch (e) {
            console.error(e);
        }
    })


});