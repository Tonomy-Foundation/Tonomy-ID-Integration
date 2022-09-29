import { KeyManagerLevel, initialize } from 'tonomy-id-sdk';
import { Checksum256, PrivateKey } from '@greymass/eosio';
import JsKeyManager from './services/jskeymanager';
import JsStorage from './services/jsstorage';

const keyManager = new JsKeyManager();
const storage = new JsStorage();
const user = initialize(keyManager, storage);

describe('Keymanager class', () => {
    test('KeyManagerLevel enum helpers', () => {
        const passwordLevel = KeyManagerLevel.PASSWORD;
        expect(passwordLevel).toBe('PASSWORD');
        expect(KeyManagerLevel.indexFor(passwordLevel)).toBe(0);
        expect(KeyManagerLevel.from('PASSWORD')).toBe(passwordLevel);
    });

    test('savePassword() is defined', () => {
        expect(user.savePassword).toBeDefined();
    });

    test('generatePrivateKeyFromPassword() returns privatekey', async () => {
        const password = "123";
        const { privateKey, salt } = await keyManager.generatePrivateKeyFromPassword(password)
        expect(privateKey).toBeInstanceOf(PrivateKey);
        expect(salt).toBeDefined();
    })

    test('generatePrivateKeyFromPassword() password can be verfied', async () => {
        const password = "123";
        const { privateKey, salt } = await keyManager.generatePrivateKeyFromPassword(password);

        const { privateKey: privateKey2 } = await keyManager.generatePrivateKeyFromPassword(password, salt);
        expect(privateKey).toEqual(privateKey2);
    })

    test('generateRandomPrivateKey() is defined', () => {
        expect(keyManager.generateRandomPrivateKey).toBeDefined();
    })

    test('generateRandomPrivateKey() generates random key', async () => {
        const r1 = keyManager.generateRandomPrivateKey();
        expect(r1).toBeInstanceOf(PrivateKey);

        const r2 = keyManager.generateRandomPrivateKey();
        expect(r1).not.toEqual(r2);
    })

    test("generates same key as RN keymanager", async () => {
        const salt: Checksum256 = Checksum256.from(Buffer.from("12345678901234567890123456789012", "utf-8"));
        const { privateKey } = await keyManager.generatePrivateKeyFromPassword("password", salt);

        expect(privateKey.toString()).toBe("PVT_K1_pPnFBQwMSQgjAenyLdMHoeFQBtazFBYEWeA12FtKpm5PEY4fc");
    })
})