import { randomString, KeyManager, createUserObject, App } from 'tonomy-id-sdk';
import { JsKeyManager } from 'tonomy-id-sdk/test/services/jskeymanager';
import { jsStorageFactory } from 'tonomy-id-sdk/test/services/jsstorage';

import { privateKey } from './eosio';

export async function createRandomID() {
    const auth: KeyManager = new JsKeyManager();
    const user = createUserObject(auth, jsStorageFactory);

    const password = randomString(8) + 'aA0!';
    const username = randomString(8);
    const pin = Math.floor(Math.random() * 5).toString();

    await user.saveUsername(username);
    await user.savePassword(password);
    await user.savePIN(pin);
    await user.saveFingerprint();
    await user.saveLocal();

    await user.createPerson();
    await user.updateKeys(password);

    return { user, password, pin, auth };
}

export async function createRandomApp(logoUrl?: string, origin?: string): Promise<App> {
    const name = randomString(8);
    const description = randomString(80);
    if (!origin) origin = 'http://localhost:3000';
    if (!logoUrl) logoUrl = 'http://localhost:3000/logo.png';

    return await App.create({
        usernamePrefix: randomString(8),
        appName: name,
        description: description,
        logoUrl,
        origin,
        publicKey: privateKey.toPublic(),
    });
}
