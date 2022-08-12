import deployContract from "./deploy-contract";
import path from 'path';
import createAccount from './create-account';

async function main() {
    // TODO
    // create and issue the system currency
    await createAccount({ account: "id.tonomy" });

    await deployContract({ account: "id.tonomy", contractDir: path.join(__dirname, "../../Tonomy-Contracts/contracts/id.tonomy") });
    // create a new person, from the eosio account
}

Promise.resolve(main()).catch(err => {
    console.error(err)
    process.exit(1)
})