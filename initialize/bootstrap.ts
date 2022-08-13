import deployContract from "./deploy-contract";
import path from 'path';
import { createAccount } from './create-account';
import { api } from "./config";

async function main() {
    await createAccount({ account: "eosio.token" });
    await deployContract({ account: "eosio.token", contractDir: path.join(__dirname, "../../Tonomy-Contracts/contracts/eosio.token") });
    await createAndIssueToken();

    await createAccount({ account: "id.tonomy" });
    await deployContract({ account: "id.tonomy", contractDir: path.join(__dirname, "../../Tonomy-Contracts/contracts/id.tonomy") });

    await deployContract({ account: "eosio", contractDir: path.join(__dirname, "../../Tonomy-Contracts/contracts/eosio.bios.tonomy") });
}

async function createAndIssueToken() {
    // TODO
    // create and issue the system currency here instead of in ./blockchain/initalize-blockchain.sh
    await api.transact({
        actions: [
            {
                account: "eosio.token",
                name: "create",
                authorization: [
                    {
                        actor: "eosio.token",
                        permission: 'active',
                    },
                ],
                data: {
                    issuer: "eosio.token",
                    maximum_supply: "10000000000.0000 SYS",
                },
            }, {
                account: "eosio.token",
                name: "issue",
                authorization: [
                    {
                        actor: "eosio.token",
                        permission: 'active',
                    },
                ],
                data: {
                    to: "eosio.token",
                    quantity: "1000000000.0000 SYS",
                    memo: ""
                },
            }
        ],
    },
        {
            blocksBehind: 3,
            expireSeconds: 30,
        });
}

Promise.resolve(main()).catch(err => {
    console.error(err)
    process.exit(1)
})