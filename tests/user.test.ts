import { JsAuthenticator, User } from 'tonomy-id-sdk';
import { api } from './services/eosio';

beforeEach((): void => {
    jest.setTimeout(60000);
});

test('Create a new ID of a person', async () => {
    const auth = new JsAuthenticator();

    const user = new User(auth);

    // user.savePassword("myPassword123!");
    // user.savePIN("4568");
    // user.saveFingerprint();
    // user.saveLocal();

    await user.createPerson("jack2233");

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