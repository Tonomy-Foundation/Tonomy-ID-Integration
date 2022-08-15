import { EosioUtil } from 'tonomy-id-sdk';
const { createKeyAuthoriy, addCodePermission, publicKey } = EosioUtil;
import { EosioContract } from 'tonomy-id-sdk';

const eosioContract: EosioContract = EosioContract.Instance;

async function createAccount({ account }) {
    const ownerAuth = createKeyAuthoriy(publicKey.toString());

    // need to add the eosio.code authority as well
    // https://developers.eos.io/welcome/v2.1/smart-contract-guides/adding-inline-actions#step-1-adding-eosiocode-to-permissions
    const activeAuth = addCodePermission(ownerAuth, account)

    console.log(`Creating new account ${account}`)
    await eosioContract.newaccount("eosio", account, ownerAuth, activeAuth);
}

export { createAccount };