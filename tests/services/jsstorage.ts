import { PersistantStorage } from 'tonomy-id-sdk';

export default class JsStorage implements PersistantStorage {
    private _storage: any;
    constructor() {
        this._storage = {};
    }

    async retrieve(key: string): Promise<any> {
        return this._storage[key];
    }

    async store(key: string, value: any): Promise<void> {
        this._storage[key] = value;
    }

    async clear(): Promise<void> {
        this._storage = {};
    }
}
