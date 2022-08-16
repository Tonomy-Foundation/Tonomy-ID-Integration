import { EosioUtil } from 'tonomy-id-sdk';
const { publicKey } = EosioUtil;
import { Authority, EosioContract } from 'tonomy-id-sdk';

const eosioContract: EosioContract = EosioContract.Instance;

async function createAccount({ account }) {
    const ownerAuth = Authority.fromKey(publicKey.toString());

    const activeAuth = Authority.fromKey(publicKey.toString());
    // need to add the eosio.code authority as well so that it can call eosio from the smart contract
    activeAuth.addCodePermission("eosio");

    console.log(`Creating new account ${account}`)
    await eosioContract.newaccount("eosio", account, ownerAuth, activeAuth);
}

export { createAccount };