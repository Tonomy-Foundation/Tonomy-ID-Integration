import deployContract from "./deploy-contract";
import path from 'path';
import { createAccount } from './create-account';
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
    try {
        const result = await api.transact(
            {
                actions: [
                    {
                        account: "id.tonomy",
                        name: "newperson",
                        authorization: [
                            {
                                actor: "id.tonomy",
                                permission: 'active',
                            },
                        ],
                        data: {
                            creator: "id.tonomy",
                            username_hash: "7d32c90f59b2131f86132a30172a8adbb3e839110e38874901afc61d971d7d0e",
                            password: publicKey.toString(),
                            salt: "b9776d7ddf459c9ad5b0e1d6ac61e27befb5e99fd62446677600d7cacef544d0",
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

        console.log("action console:")
        console.log(result.processed.action_traces[0].console);
    } catch (error) {
        console.log(JSON.stringify(error, null, 2))
    }
}

Promise.resolve(main()).catch(err => {
    console.error(err)
    process.exit(1)
})