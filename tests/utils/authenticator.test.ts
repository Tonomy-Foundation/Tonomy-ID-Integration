import { Authenticator, AuthenticatorLevel } from 'tonomy-id-sdk';

class JsAuthenticator implements Authenticator {
    createPermission(level: AuthenticatorLevel, privateKey: string, challenge: string): string {
        return "eateh";
    }
}

test('true', () => {
    expect(true).toBeTruthy();
});