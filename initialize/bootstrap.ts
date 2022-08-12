import deployContract from "./deploy-contract";
import path from 'path';
import createAccount from './create-account';
import { api, publicKey } from "./config";

async function main() {
    // TODO
    // create and issue the system currency

    await createAccount({ account: "id.tonomy" });
    await deployContract({ account: "id.tonomy", contractDir: path.join(__dirname, "../../Tonomy-Contracts/contracts/id.tonomy") });

    await callnewperson();
}

async function callnewperson() {
    console.log(`Calling id.tonomy::newperson`)
    const result = await api.transact(
        {
            actions: [
                {
                    account: "id.tonomy",
                    name: "newperson",
                    authorization: [
                        {
                            actor: "eosio",
                            permission: 'active',
                        },
                    ],
                    data: {
                        creator: "eosio",
                        username_hash: "7d32c90f59b2131f86132a30172a8adbb3e839110e38874901afc61d971d7d0e",
                        password: publicKey.toString(),
                        salt: "7d32c90f59b2131f86132a30172a8adbb3e839110e38874901afc61d971d7d0e",
                        pin: publicKey.toString(),
                        fingerprint: publicKey.toString()
                    },
                }
            ],
        },
        {
            blocksBehind: 3,
            expireSeconds: 30,
        }
    )

}

Promise.resolve(main()).catch(err => {
    console.error(err)
    process.exit(1)
})