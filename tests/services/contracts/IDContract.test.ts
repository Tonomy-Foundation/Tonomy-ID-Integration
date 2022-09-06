import { IDContract, sha256 } from 'tonomy-id-sdk';
import { createRandomID } from '../../util/user';

const idContract = IDContract.Instance;

describe("IDContract tests", () => {
    beforeEach((): void => {
        jest.setTimeout(60000);
    });

    test('getAccountTonomyIDInfo(): Fetch ID details of a user', async () => {
        const { user } = await createRandomID();

        // get by username
        let idInfo = await idContract.getAccountTonomyIDInfo(user.accountName);
        expect(idInfo.account_name).toEqual(user.accountName.toString());
        expect(idInfo.username_hash).toEqual(sha256(user.username));
        expect(idInfo.status).toEqual(0); // 0 = Creating
        expect(idInfo.type).toEqual(0); // 0 = Person
        expect(idInfo.password_salt).toEqual(user.salt.toString());

        // get by username
        idInfo = await idContract.getAccountTonomyIDInfo(user.username);
        expect(idInfo.account_name).toEqual(user.accountName.toString());
        expect(idInfo.username_hash).toEqual(sha256(user.username));
    });
})