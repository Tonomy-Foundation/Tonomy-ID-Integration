import { KeyManagerLevel, User } from 'tonomy-id-sdk';
import { PrivateKey } from '@greymass/eosio';
import argon2 from 'argon2';
import JsKeyManager from './services/jskeymanager';

const keyManager = new JsKeyManager();
const user = new User(keyManager);

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

        // TODO fix to use overloaded generatePrivateKeyFromPassword(password, salt) to check
        const data = Buffer.from(privateKey.data.array)
        const result = await argon2.verify(data.toString(), password, { salt: Buffer.from(salt.toString()), hashLength: 32, type: argon2.argon2id, raw: true });
        expect(result).toBe(true);
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
})