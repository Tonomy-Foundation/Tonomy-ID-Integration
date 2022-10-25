import { randomString, KeyManager, initialize } from 'tonomy-id-sdk';
import { PersistantStorage } from 'tonomy-id-sdk';
import JsKeyManager from '../services/jskeymanager';
import JsStorage from '../services/jsstorage';
import settings from '../services/settings';

export async function createRandomID() {
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
