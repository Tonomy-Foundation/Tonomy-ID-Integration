
import { JsAuthenticator, User, randomString } from 'tonomy-id-sdk';

export async function createRandomID() {
    const auth = new JsAuthenticator();
    const user = new User(auth);

    const username = randomString(10);
    const password = randomString(32);
    const pin = Math.floor(Math.random() * 5).toString();

    await user.savePassword(password);
    await user.savePIN(pin);
    await user.saveFingerprint();
    await user.saveLocal();

    await user.createPerson(username, password);
    return { user, password, pin };
}