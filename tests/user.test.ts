// need to use API types from inside tonomy-id-sdk, otherwise type compatibility issues
import { API as SDK_API } from 'tonomy-id-sdk/node_modules/@greymass/eosio';
import { api } from './util/eosio';
import { createRandomID } from './util/user';
import { KeyManager, KeyManagerLevel, sha256, initialize, User, PersistantStorage } from 'tonomy-id-sdk';
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

    test('savePassword() generates and saves new private key', async () => {
        expect(user.savePassword).toBeDefined();

        expect(() => user.keyManager.getKey({ level: KeyManagerLevel.PASSWORD })).rejects.toThrowError(Error);
        expect(await user.storage.salt).not.toBeDefined();
        await user.savePassword('myPassword123!');
        expect(user.keyManager.getKey({ level: KeyManagerLevel.PASSWORD })).resolves.toBeDefined();
        expect(await user.storage.salt).toBeDefined();
    });

    test('savePIN() saves new private key', async () => {
        expect(() => user.keyManager.getKey({ level: KeyManagerLevel.PIN })).rejects.toThrowError(Error);
        await user.savePIN('4568');
        expect(user.keyManager.getKey({ level: KeyManagerLevel.PIN })).resolves.toBeDefined();
    });

    test('saveFingerprint() saves new private key', async () => {
        expect(() => user.keyManager.getKey({ level: KeyManagerLevel.FINGERPRINT })).rejects.toThrowError(Error);
        await user.saveFingerprint();
        expect(user.keyManager.getKey({ level: KeyManagerLevel.FINGERPRINT })).resolves.toBeDefined();
    });

    test('saveLocal() saves new private key', async () => {
        expect(() => user.keyManager.getKey({ level: KeyManagerLevel.LOCAL })).rejects.toThrowError(Error);
        await user.saveLocal();
        expect(user.keyManager.getKey({ level: KeyManagerLevel.LOCAL })).resolves.toBeDefined();
    });

    test('createPerson(): Create a new ID of a person', async () => {
        const { user } = await createRandomID();

        const accountName = await user.storage.accountName;

        const accountInfo = await api.v1.chain.get_account(accountName);

        expect(accountInfo).toBeDefined();
        expect(accountInfo.account_name.toString()).toBe(accountName.toString());

        // Password key
        expect(accountInfo.getPermission('owner').required_auth.threshold.toNumber()).toBe(1);
        expect(accountInfo.getPermission('owner').required_auth.keys[0].key).toBeDefined();

        // PIN key
        expect(accountInfo.getPermission('pin').parent.toString()).toBe('owner');
        expect(accountInfo.getPermission('pin').required_auth.threshold.toNumber()).toBe(1);
        expect(accountInfo.getPermission('pin').required_auth.keys[0].key).toBeDefined();

        // Fingerprint key
        expect(accountInfo.getPermission('fingerprint').parent.toString()).toBe('owner');
        expect(accountInfo.getPermission('fingerprint').required_auth.threshold.toNumber()).toBe(1);
        expect(accountInfo.getPermission('fingerprint').required_auth.keys[0].key).toBeDefined();

        // Local key
        expect(accountInfo.getPermission('local').parent.toString()).toBe('owner');
        expect(accountInfo.getPermission('local').required_auth.threshold.toNumber()).toBe(1);
        expect(accountInfo.getPermission('local').required_auth.keys[0].key).toBeDefined();

        // Active key
        expect(accountInfo.getPermission('active').parent.toString()).toBe('owner');
        expect(accountInfo.getPermission('active').required_auth.threshold.toNumber()).toBe(1);
        expect(accountInfo.getPermission('active').required_auth.keys[0].key).toBeDefined();
    });

    test('login() logs in with password', async () => {
        const { user, password } = await createRandomID();

        const username = await user.storage.username;

        const newKeyManager = new JsKeyManager();
        const userLogin = initialize(newKeyManager, storage, settings);

        expect(userLogin.isLoggedIn()).resolves.toBeFalsy();
        const idInfo = await userLogin.login(username, password);

        expect(idInfo.username_hash.toString()).toBe(sha256(username));
        expect(userLogin.keyManager.getKey({ level: KeyManagerLevel.PASSWORD })).resolves.toBeDefined();
        expect(await userLogin.storage.accountName).toBeDefined();
        expect(await userLogin.storage.username).toBe(username);
        expect(userLogin.isLoggedIn()).toBeTruthy();
    });

    test('login() fails with wrong password', async () => {
        const { user } = await createRandomID();

        const username = await user.storage.username;

        const newKeyManager = new JsKeyManager();
        const userLogin = initialize(newKeyManager, storage, settings);

        await expect(() => userLogin.login(username, 'differentpassword')).rejects.toThrowError(Error);
    });

    test('logout', async () => {
        const { user, password } = await createRandomID();

        await user.logout();

        expect(await user.storage.status).toBeFalsy();
        expect(() => user.keyManager.getKey({ level: KeyManagerLevel.PASSWORD })).rejects.toThrowError(Error);
        expect(() => user.keyManager.getKey({ level: KeyManagerLevel.PIN })).rejects.toThrowError(Error);
        expect(() => user.keyManager.getKey({ level: KeyManagerLevel.FINGERPRINT })).rejects.toThrowError(Error);
        expect(() => user.keyManager.getKey({ level: KeyManagerLevel.LOCAL })).rejects.toThrowError(Error);
        expect(user.isLoggedIn()).resolves.toBeFalsy();
    });

    test('getAccountInfo(): Get ID information', async () => {
        const { user } = await createRandomID();

        // get by account name
        let userInfo = await User.getAccountInfo(await user.storage.accountName);

        expect(userInfo).toBeInstanceOf(SDK_API.v1.AccountObject);
        expect(userInfo.account_name).toEqual(await user.storage.accountName);

        // get by username
        userInfo = await User.getAccountInfo(await user.storage.username);

        expect(userInfo).toBeInstanceOf(SDK_API.v1.AccountObject);
        expect(userInfo.account_name).toEqual(await user.storage.accountName);
    });
});
