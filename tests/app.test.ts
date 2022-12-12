// need to use API types from inside tonomy-id-sdk, otherwise type compatibility issues
import { createRandomApp, createRandomID } from './util/user';
import { KeyManager, initialize, User, PersistentStorage } from 'tonomy-id-sdk';
import JsKeyManager from './services/jskeymanager';
import JsStorage from './services/jsstorage';
import settings from './services/settings';

let auth: KeyManager;
let storage: PersistentStorage;
let user: User;

describe('App class', () => {
    beforeEach((): void => {
        jest.setTimeout(60000);
        auth = new JsKeyManager();
        storage = new JsStorage();
        user = initialize(auth, storage, settings);
    });

    test('loginWithApp(): Logs into new app', async () => {
        const { user, password } = await createRandomID();
        const userAccountName = await user.storage.accountName;

        const { accountName } = await createRandomApp();
        const newKey = auth.generateRandomPrivateKey();

        await user.app.loginWithApp(accountName, newKey.toPublic(), password);

        const accountInfo = await User.getAccountInfo(userAccountName);

        const permissions = accountInfo.permissions;
        const appPermission = permissions.find((p) => p.perm_name.toString() === accountName.toString());

        expect(appPermission).toBeDefined();
        expect(appPermission.parent.toString()).toEqual('active');
        expect(appPermission.required_auth.keys[0].key.toString()).toEqual(newKey.toPublic().toString());
    });
});
