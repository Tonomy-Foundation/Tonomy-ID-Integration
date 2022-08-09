import { JsAuthenticator, User } from 'tonomy-id-sdk';
import { APIClient } from '@greymass/eosio';

test('Create a new account', async () => {
    const auth = new JsAuthenticator();

    const user = new User(auth);

    user.savePassword("myPassword123!");
    user.savePIN("4568");
    user.saveFingerprint();

    await user.createPerson("jack");
    const accountName = user.accountName.toString();

    const eosioClient = new APIClient({ url: "http://localhost:8888" });
    const accountInfo = await eosioClient.v1.chain.get_account(accountName);

    expect(accountInfo).toBeDefined();
    expect(accountInfo.account_name).toBe(accountName);

    // password key
    expect(accountInfo.getPermission("owner").required_auth.threshold).toBe(1);
    expect(accountInfo.getPermission("owner").required_auth.keys[0].key).toBeDefined();

    // PIN key
    expect(accountInfo.getPermission("pin").parent.toString()).toBe("owner");
    expect(accountInfo.getPermission("pin").required_auth.threshold).toBe(1);
    expect(accountInfo.getPermission("pin").required_auth.keys[0].key).toBeDefined();

    // Fingerprint key
    expect(accountInfo.getPermission("finger").parent.toString()).toBe("owner");
    expect(accountInfo.getPermission("finger").required_auth.threshold).toBe(1);
    expect(accountInfo.getPermission("finger").required_auth.keys[0].key).toBeDefined();
});