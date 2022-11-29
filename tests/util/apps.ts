import { Name } from '@greymass/eosio';
import {
    randomString,
    KeyManager,
    initialize,
    IDContract,
    EosioUtil,
    AccountType,
    TonomyUsername,
    PersistantStorage,
} from 'tonomy-id-sdk';
import JsKeyManager from '../services/jskeymanager';
import JsStorage from '../services/jsstorage';
import settings from '../services/settings';
import { privateKey } from './eosio';

const idContract: IDContract = IDContract.Instance;

export async function createRandomApp() {
    const auth: KeyManager = new JsKeyManager();
    const storage: PersistantStorage = new JsStorage();
    const user = initialize(auth, storage, settings);

    const password = randomString(8);
    const username = randomString(8);
    const pin = Math.floor(Math.random() * 5).toString();

    await user.saveUsername(username, '.test.id');
    await user.savePassword(password);
    await user.savePIN(pin);
    await user.saveFingerprint();
    await user.saveLocal();

    await user.createPerson();
    await user.updateKeys(password);

    return { user, password, pin };
}

export async function createRandomApp(logo_url?: string, origin?: string) {
    const name = randomString(8);
    const description = randomString(80);
    const username = new TonomyUsername(randomString(8), AccountType.APP, '.test.id');
    if (!origin) origin = 'http://localhost:3000';
    if (!logo_url) logo_url = 'http://localhost:3000/logo.png';

    const res = await idContract.newapp(
        name,
        description,
        username.usernameHash,
        logo_url,
        origin,
        privateKey.toPublic(),
        EosioUtil.createSigner(privateKey)
    );

    const newAccountAction = res.processed.action_traces[0].inline_traces[0].act;
    const accountName = Name.from(newAccountAction.data.name);

    return { name, description, username, logo_url, origin, accountName };
}
