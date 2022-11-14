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
        'Payable.sol': {
            content: fs.readFileSync("./exercices/ex05 - Payable/sources/Payable.sol", "utf-8")
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
const abi = contracts['Payable.sol']['Payable'].abi;
const bytecode = contracts['Payable.sol']['Payable'].evm.bytecode;

const getAccounts = async () => {
    return await web3.eth.getAccounts();
};

mocha.describe('Payable', () => {

    mocha.it('Has been deployed', async () => {
        try {
            const accounts = await getAccounts();
            const contract = await new web3.eth.Contract(abi)
                .deploy({ data: bytecode.object })
                .send({ from: accounts[0], gas: 2000000 , value:2});

            assert.ok(contract.options.address);

        } catch (e) {
            console.error(e);
        }
    })

    mocha.it('Has been deployed without money', async () => {
        try {
        
            try {
                await new web3.eth.contract(abi)
                .deploy({ data: bytecode.object.toString() })
                .send({ from: accounts[0], gas: 2000000,value:0});
                assert.strictEqual(false, true);
            } catch (e) {
                assert.strictEqual(true, true);
            }

        } catch (e) {
            console.error(e);
        }
    })
});