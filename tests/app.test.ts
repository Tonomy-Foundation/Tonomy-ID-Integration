// need to use API types from inside tonomy-id-sdk, otherwise type compatibility issues
import { createRandomApp, createRandomID } from './util/user';
import { User, setSettings, AppStatus } from 'tonomy-id-sdk';
import settings from './services/settings';

setSettings(settings);

describe('App class', () => {
    test('loginWithApp(): Logs into new app', async () => {
        const { user, password, auth } = await createRandomID();
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

        const userApps = await user.app.storage.apps;
        expect(userApps.length).toBe(1);
        const myApp = userApps[0];
        expect(myApp.account).toEqual(accountName.toString());
        expect(myApp.status).toEqual(AppStatus.READY);
        expect(myApp.added).toBeDefined();
    });
});
