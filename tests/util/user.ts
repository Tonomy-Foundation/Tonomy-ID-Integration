
import { User, randomString, KeyManager, initialize } from 'tonomy-id-sdk';
import { PersistantStorage } from 'tonomy-id-sdk';
import JsKeyManager from '../services/jskeymanager';
import JsStorage from '../services/jsstorage';

export async function createRandomID() {
    const auth: KeyManager = new JsKeyManager();
    const storage: PersistantStorage = new JsStorage();
    const user = initialize(auth, storage);

    const password = randomString(8);
    const username = randomString(8);
    const pin = Math.floor(Math.random() * 5).toString();

    await user.savePassword(password);
    await user.savePIN(pin);
    await user.saveFingerprint();
    await user.saveLocal();

    await user.createPerson(username, password);

    return { user, password, pin };
}