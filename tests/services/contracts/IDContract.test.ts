import { IDContract, sha256 } from 'tonomy-id-sdk';
import { createRandomID } from '../../util/user';

const idContract = IDContract.Instance;

describe("IDContract class", () => {
    beforeEach((): void => {
        jest.setTimeout(60000);
    });

    test('getAccountTonomyIDInfo(): Fetch ID details of a user', async () => {
        const { user } = await createRandomID();

        // get by username
        let idInfo = await idContract.getAccountTonomyIDInfo(user.accountName);

        expect(idInfo.account_name).toEqual(user.accountName);
        expect(idInfo.username_hash.toString()).toEqual(sha256(user.username));
        expect(idInfo.status).toEqual(0); // 0 = Creating. TODO turn into enum string
        // expect(idInfo.type).toEqual(0); // 0 = Person // TODO bring back type property (as enum string) based on account_name[0] character
        expect(idInfo.account_name.toString()[0]).toEqual('p'); // p = person
        expect(idInfo.password_salt).toEqual(user.salt);
        expect(idInfo.version).toBe(1);

        // get by username
        idInfo = await idContract.getAccountTonomyIDInfo(user.username);
        expect(idInfo.account_name.toString()).toEqual(user.accountName.toString());
        expect(idInfo.username_hash.toString()).toEqual(sha256(user.username));
    });
})