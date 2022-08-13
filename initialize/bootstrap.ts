import deployContract from "./deploy-contract";
import path from 'path';
import { createAccount } from './create-account';
import { api, publicKey } from "./config";

async function main() {
    // TODO
    // create and issue the system currency here instead of in ./blockchain/initalize-blockchain.sh

    await createAccount({ account: "id.tonomy" });
    await deployContract({ account: "id.tonomy", contractDir: path.join(__dirname, "../../Tonomy-Contracts/contracts/id.tonomy") });
}

Promise.resolve(main()).catch(err => {
    console.error(err)
    process.exit(1)
})