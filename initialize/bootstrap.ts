import deployContract from "./deploy-contract";
import path from 'path';
import { createAccount } from './create-account';
import { EosioTokenContract } from 'tonomy-id-sdk';

const eosioTokenContract = EosioTokenContract.Instance;

async function main() {
    await createAccount({ account: "eosio.token" });
    await deployContract({ account: "eosio.token", contractDir: path.join(__dirname, "../../Tonomy-Contracts/contracts/eosio.token") });
    await eosioTokenContract.create("1000000000 SYS");
    await eosioTokenContract.issue("100000000 SYS");

    await createAccount({ account: "id.tonomy" });
    await deployContract({ account: "id.tonomy", contractDir: path.join(__dirname, "../../Tonomy-Contracts/contracts/id.tonomy") });

    await deployContract({ account: "eosio", contractDir: path.join(__dirname, "../../Tonomy-Contracts/contracts/eosio.bios.tonomy") });
}

Promise.resolve(main()).catch(err => {
    console.error(err)
    process.exit(1)
})