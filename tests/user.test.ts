import { Name } from '@greymass/eosio';
// need to use API types from inside tonomy-id-sdk, otherwise type compatibility issues
import { API as SDK_API } from 'tonomy-id-sdk/node_modules/@greymass/eosio';
import { User, randomString } from 'tonomy-id-sdk';
import { api } from './services/eosio';
import JsKeyManager from './services/jskeymanager';


export async function createRandomID() {
    const auth = new JsKeyManager();
    const user = new User(auth);

    const username = randomString(10);
    const password = randomString(32);
    const pin = Math.floor(Math.random() * 5).toString();
    // user.savePassword(password);
    // user.savePIN(pin;
    // user.saveFingerprint();
    // user.saveLocal();

    await user.createPerson(username);
    return { user, password, pin };
}

describe("User tests", () => {
    beforeEach((): void => {
        jest.setTimeout(60000);
    });

    test("createPerson(): Create a new ID of a person", async () => {
        const auth = new JsKeyManager();
        const user = new User(auth);

        // user.savePassword("myPassword123!");
        // user.savePIN("4568");
        // user.saveFingerprint();
        // user.saveLocal();

        await user.createPerson(randomString(4));

        const accountName = user.accountName;

        // for this call to work:
        // node_modules/@greymass/eosio/lib/eosio-core.js:L1239
        // replace "throw new Error(`Unexpectedly encountered ${value} for non-optional`);"
        // with "return null"
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

    test("getAccountInfo(): Get ID information", async () => {
        const { user } = await createRandomID();

        // get by account name
        let userInfo = await User.getAccountInfo(user.accountName);

        expect(userInfo).toBeInstanceOf(SDK_API.v1.AccountObject);
        expect(userInfo.account_name).toEqual(user.accountName);

        // get by username
        userInfo = await User.getAccountInfo(user.username);

        expect(userInfo).toBeInstanceOf(SDK_API.v1.AccountObject);
        expect(userInfo.account_name).toEqual(user.accountName);
    });
})
