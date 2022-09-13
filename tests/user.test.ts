// need to use API types from inside tonomy-id-sdk, otherwise type compatibility issues
import { API as SDK_API } from 'tonomy-id-sdk/node_modules/@greymass/eosio';
import { api } from './util/eosio';
import { createRandomID } from './util/user';
import { KeyManager, KeyManagerLevel, sha256, initialize, User } from 'tonomy-id-sdk';
import JsKeyManager from './services/jskeymanager';
import { PersistantStorage } from 'tonomy-id-sdk/dist/storage';
import MockStorage from './services/mockstorage';

let auth: KeyManager;
let user: User;
let storage: PersistantStorage;
describe("User class", () => {
    beforeEach((): void => {
        jest.setTimeout(60000);
        auth = new JsKeyManager();
        storage = new MockStorage();
        user = initialize(auth, storage);
    });

    test("savePassword() generates and saves new private key", async () => {
        expect(user.savePassword).toBeDefined();

        expect(() => user.keyManager.getKey({ level: KeyManagerLevel.PASSWORD })).toThrowError(Error);
        expect(user.storage.salt).not.toBeDefined();
        await user.savePassword("myPassword123!");
        expect(user.keyManager.getKey({ level: KeyManagerLevel.PASSWORD })).toBeDefined();
        expect(user.storage.salt).toBeDefined();
    });

    test("savePIN() saves new private key", async () => {
        expect(() => user.keyManager.getKey({ level: KeyManagerLevel.PIN })).toThrowError(Error);
        await user.savePIN("4568");
        expect(user.keyManager.getKey({ level: KeyManagerLevel.PIN })).toBeDefined();
    });

    test("saveFingerprint() saves new private key", async () => {
        expect(() => user.keyManager.getKey({ level: KeyManagerLevel.FINGERPRINT })).toThrowError(Error);
        await user.saveFingerprint();
        expect(user.keyManager.getKey({ level: KeyManagerLevel.FINGERPRINT })).toBeDefined();
    });

    test("saveLocal() saves new private key", async () => {
        expect(() => user.keyManager.getKey({ level: KeyManagerLevel.LOCAL })).toThrowError(Error);
        await user.saveLocal();
        expect(user.keyManager.getKey({ level: KeyManagerLevel.LOCAL })).toBeDefined();
    });

    test("createPerson(): Create a new ID of a person", async () => {
        const { user } = await createRandomID();

        const accountName = user.storage.accountName;

        const accountInfo = await api.v1.chain.get_account(accountName);

        expect(accountInfo).toBeDefined();
        expect(accountInfo.account_name.toString()).toBe(accountName.toString());

        // Password key
        expect(accountInfo.getPermission("owner").required_auth.threshold.toNumber()).toBe(1);
        expect(accountInfo.getPermission("owner").required_auth.keys[0].key).toBeDefined();

        // PIN key
        expect(accountInfo.getPermission("pin").parent.toString()).toBe("owner");
        expect(accountInfo.getPermission("pin").required_auth.threshold.toNumber()).toBe(1);
        expect(accountInfo.getPermission("pin").required_auth.keys[0].key).toBeDefined();

        // Fingerprint key
        expect(accountInfo.getPermission("fingerprint").parent.toString()).toBe("owner");
        expect(accountInfo.getPermission("fingerprint").required_auth.threshold.toNumber()).toBe(1);
        expect(accountInfo.getPermission("fingerprint").required_auth.keys[0].key).toBeDefined();

        // Local key
        expect(accountInfo.getPermission("local").parent.toString()).toBe("owner");
        expect(accountInfo.getPermission("local").required_auth.threshold.toNumber()).toBe(1);
        expect(accountInfo.getPermission("local").required_auth.keys[0].key).toBeDefined();

        // Active key
        expect(accountInfo.getPermission("active").parent.toString()).toBe("owner");
        expect(accountInfo.getPermission("active").required_auth.threshold.toNumber()).toBe(1);
        expect(accountInfo.getPermission("active").required_auth.keys[0].key).toBeDefined();
    });

    test("login() logs in with password", async () => {
        const { user, password } = await createRandomID();

        const username = user.storage.username;

        const newKeyManager = new JsKeyManager();
        const userLogin = initialize(newKeyManager, storage);

        expect(userLogin.isLoggedIn()).toBeFalsy();
        const idInfo = await userLogin.login(username, password);

        expect(idInfo.username_hash.toString()).toBe(sha256(username));
        expect(userLogin.keyManager.getKey({ level: KeyManagerLevel.PASSWORD })).toBeDefined();
        expect(userLogin.storage.accountName).toBeDefined();
        expect(userLogin.storage.username).toBe(username);
        expect(userLogin.isLoggedIn()).toBeTruthy();
    });

    test("login() fails with wrong password", async () => {
        const { user } = await createRandomID();

        const username = user.storage.username;

        const newKeyManager = new JsKeyManager();
        const userLogin = initialize(newKeyManager, storage);

        await expect(() => userLogin.login(username, "differentpassword")).rejects.toThrowError(Error);
    });
    test('logout', async () => {
        const { user, password } = await createRandomID();

        user.logout();
        console.log(user.storage)
        expect(user.storage.status).toBeFalsy();
        expect(user.keyManager.getKey({ level: KeyManagerLevel.PASSWORD })).toBeFalsy();
        expect(user.isLoggedIn()).toBeFalsy();
    })
    test("getAccountInfo(): Get ID information", async () => {
        const { user } = await createRandomID();

        // get by account name
        let userInfo = await User.getAccountInfo(user.storage.accountName);

        expect(userInfo).toBeInstanceOf(SDK_API.v1.AccountObject);
        expect(userInfo.account_name).toEqual(user.storage.accountName);

        // get by username
        userInfo = await User.getAccountInfo(user.storage.username);

        expect(userInfo).toBeInstanceOf(SDK_API.v1.AccountObject);
        expect(userInfo.account_name).toEqual(user.storage.accountName);
    });

})
