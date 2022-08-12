import { api, publicKey } from "./config";

function createKeyAuthoriy(key: string) {
    return {
        threshold: 1,
        keys: [{
            key,
            weight: 1
        }],
        accounts: [],
        waits: []
    }
}

function createDelegatedAuthority(permission: { actor: string, permission: string }) {
    return {
        threshold: 1,
        keys: [],
        accounts: [{
            permission,
            weight: 1
        }],
        waits: []
    }
}

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
                        active: authory
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

export default createAccount;