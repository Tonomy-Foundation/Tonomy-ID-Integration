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

function addCodePermission(authority: any, account: string) {
    // TODO this modifies the argument. need to create copy and return a new object
    authority.accounts.push({
        permission: {
            actor: account,
            permission: "eosio.code"
        },
        weight: 1
    })
    return authority;
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