import { publicKey } from './keys';
import { Authority, EosioContract } from 'tonomy-id-sdk';

const eosioContract: EosioContract = EosioContract.Instance;

async function createAccount({ account }, signer) {
    const ownerAuth = Authority.fromKey(publicKey.toString());

    const activeAuth = Authority.fromKey(publicKey.toString());

    // need to add the eosio.code authority as well so that it can call eosio from the smart contract
    ownerAuth.addCodePermission(account);
    activeAuth.addCodePermission(account);
    await eosioContract.newaccount("eosio", account, ownerAuth, activeAuth, signer);
}

export { createAccount };