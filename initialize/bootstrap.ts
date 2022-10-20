import deployContract from './deploy-contract';
import path from 'path';
import { createAccount } from './create-account';
import { EosioTokenContract, setSettings } from 'tonomy-id-sdk';
import { signer } from './keys';

setSettings({ blockchainUrl: 'http://localhost:8888' });
const eosioTokenContract = EosioTokenContract.Instance;

async function main() {
    await createAccount({ account: 'eosio.token' }, signer);
    await deployContract(
        { account: 'eosio.token', contractDir: path.join(__dirname, '../../Tonomy-Contracts/contracts/eosio.token') },
        signer
    );
    await eosioTokenContract.create('1000000000 SYS', signer);
    await eosioTokenContract.issue('100000000 SYS', signer);

    await createAccount({ account: 'id.tonomy' }, signer);
    await deployContract(
        { account: 'id.tonomy', contractDir: path.join(__dirname, '../../Tonomy-Contracts/contracts/id.tonomy') },
        signer
    );

    await deployContract(
        { account: 'eosio', contractDir: path.join(__dirname, '../../Tonomy-Contracts/contracts/eosio.bios.tonomy') },
        signer
    );
}

Promise.resolve(main()).catch((err) => {
    console.error(err);
    process.exit(1);
});
