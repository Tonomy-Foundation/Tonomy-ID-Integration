// need to use API types from inside tonomy-id-sdk, otherwise type compatibility issues
import { API as SDK_API } from 'tonomy-id-sdk/node_modules/@greymass/eosio';
import { api } from './util/eosio';
import { createRandomApp, createRandomID } from './util/user';
import { KeyManager, initialize, User, PersistantStorage } from 'tonomy-id-sdk';
import JsKeyManager from './services/jskeymanager';
import JsStorage from './services/jsstorage';
import settings from './services/settings';

let auth: KeyManager;
let storage: PersistantStorage;
let user: User;

describe('User class', () => {
    beforeEach((): void => {
        jest.setTimeout(60000);
        auth = new JsKeyManager();
        storage = new JsStorage();
        user = initialize(auth, storage, settings);
    });

    test('loginWithApp(): Logs into new app', async () => {
        const { user } = await createRandomID();
        const accountName = await user.storage.accountName;

        const { app } = await createRandomApp();
        const newKey = auth.generateRandomPrivateKey();

        await user.apps.loginWithApp(app.accountName, newKey.toPublic());

        const accountInfo = await User.getAccountInfo(accountName);
        const permissions = accountInfo.permissions;
        const appPermission = permissions.find((p) => p.perm_name === app.accountName);

        expect(appPermission).toBeDefined();
        expect(appPermission.parent).toEqual('active');
        expect(appPermission.required_auth.keys[0]).toEqual(newKey.toPublic().toString());
    });
});
