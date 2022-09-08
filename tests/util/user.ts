
import { User, randomString, KeyManager } from 'tonomy-id-sdk';
import JsKeyManager from '../services/jskeymanager';

export async function createRandomID() {
    const auth: KeyManager = new JsKeyManager();
    const user = new User(auth);

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