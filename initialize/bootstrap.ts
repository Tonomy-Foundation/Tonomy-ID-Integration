import { JsAuthenticator, User } from 'tonomy-id-sdk';
import { APIClient } from '@greymass/eosio';
import deployContract from "./deploy-contract";

async function main() {
    // TODO
    // create and issue the system currency
    await deployContract({ account: "id.tonomy", contractDir: "../Tonomy-Contracts/contracts/id.tonomy" });
    // create a new person, from the eosio account
}

Promise.resolve(main()).catch(err => {
    console.error(err)
    process.exit(1)
})