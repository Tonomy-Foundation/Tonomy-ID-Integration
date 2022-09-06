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
});

describe('saving a password', () => {
    test('function savePassword is defined', () => {
        expect(user.savePassword).toBeDefined();
    });

    test('generate private key returns privatekey', async () => {
        const { privateKey, salt } = await keyManager.generatePrivateKeyFromPassword('123')
        expect(privateKey).toBeInstanceOf(PrivateKey);
        expect(salt).toBeDefined();
    })

    test('password can be verfied', async () => {
        const password = '123'
        const { privateKey, salt } = await keyManager.generatePrivateKeyFromPassword(password);
        const data = Buffer.from(privateKey.data.array)
        const result = await argon2.verify(data.toString(), password, { salt });
        expect(result).toBe(true);
    })
})

describe('generates random keys', () => {
    test('function generateRandomPrivateKey is defined', () => {
        expect(keyManager.generateRandomPrivateKey).toBeDefined();
    })

    test('generate random key', async () => {
        const r1 = keyManager.generateRandomPrivateKey();
        expect(r1).toBeInstanceOf(PrivateKey);

        const r2 = keyManager.generateRandomPrivateKey();
        expect(r1).not.toEqual(r2);
    })
})