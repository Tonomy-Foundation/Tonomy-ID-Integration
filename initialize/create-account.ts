import { api, publicKey } from "./config";
import { createKeyAuthoriy, createDelegatedAuthority, addCodePermission } from 'tonomy-id-sdk';

async function createAccount({ account }) {
    const authory = createKeyAuthoriy(publicKey.toString());

    console.log(`Creating new account ${account}`)
    const result = await api.transact(
        {
            actions: [
                {
                    account: "eosio",
                    name: "newaccount",
                    authorization: [
                        {
                            actor: "eosio",
                            permission: 'active',
                        },
                    ],
                    data: {
                        creator: "eosio",
                        name: account,
                        owner: authory,
                        // need to add the eosio.code authority as well
                        // https://developers.eos.io/welcome/v2.1/smart-contract-guides/adding-inline-actions#step-1-adding-eosiocode-to-permissions
                        active: addCodePermission(authory, account)
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

export { createAccount };