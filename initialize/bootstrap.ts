import deployContract from './deploy-contract';
import path from 'path';
import { createAccount, createApp } from './create-account';
import { EosioTokenContract, IDContract, setSettings } from 'tonomy-id-sdk';
import { signer, publicKey } from './keys';
import address from 'address';
import settings from '../tests/services/settings';

setSettings(settings);
const eosioTokenContract = EosioTokenContract.Instance;

async function main() {
    await createAccount({ account: 'eosio.token' }, signer);
    await deployContract(
        { account: 'eosio.token', contractDir: path.join(__dirname, '../Tonomy-Contracts/contracts/eosio.token') },
        signer
    );
    await eosioTokenContract.create('1000000000 SYS', signer);
    await eosioTokenContract.issue('100000000 SYS', signer);

    await createAccount({ account: 'id.tonomy' }, signer);
    await deployContract(
        { account: 'id.tonomy', contractDir: path.join(__dirname, '../Tonomy-Contracts/contracts/id.tonomy') },
        signer
    );
    // await createAccount({ account: 'jack' }, signer);
    // await addkeylocal(signer);

    await deployContract(
        { account: 'eosio', contractDir: path.join(__dirname, '../Tonomy-Contracts/contracts/eosio.bios.tonomy') },
        signer
    );

    await createApp({
        appName: 'Market',
        usernamePrefix: 'market',
        description: 'market.com where you can buy and sell stuff ',
        origin: `http://${address.ip()}:3001`,
        logoUrl: `http://${address.ip()}:3001/market.com.png`,
        publicKey: publicKey,
    });
}

Promise.resolve(main()).catch((err) => {
    console.error(err);
    process.exit(1);
});
