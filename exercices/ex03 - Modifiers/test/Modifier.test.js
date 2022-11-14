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
        'Modifier.sol': {
            content: fs.readFileSync("./exercices/ex03 - Modifiers/sources/Modifier.sol", "utf-8")
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
const abi = contracts['Modifier.sol']['Modifier'].abi;
const bytecode = contracts['Modifier.sol']['Modifier'].evm.bytecode;

const getAccounts = async () => {
    return await web3.eth.getAccounts();
};

mocha.describe('Modifier', () => {

    mocha.it('Deploy the contract and call owner', async () => {
        try {
            const accounts = await getAccounts();
            const contract = await new web3.eth.Contract(abi)
                .deploy({ data: bytecode.object })
                .send({ from: accounts[0], gas: 1000000 });

            const res = await contract.methods.VerifOwner().call({from: accounts[0]});
            assert.strictEqual(res, true);

            try {
                await contract.methods.VerifOwner().call({from: accounts[1]});
                assert.strictEqual(false, true);
            } catch (e) {
                assert.strictEqual(true, true);
            }

        } catch (e) {
            console.error(e);
        }
    })

});