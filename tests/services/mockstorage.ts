import { PersistantStorage } from "tonomy-id-sdk/dist/storage";

export default class MockStorage implements PersistantStorage {
  private _storage: any;
  constructor() {
    this._storage = {};
  }

  retrieve(key: string): any {
    return this._storage[key];
  }

  store(key: string, value: any): void {
    this._storage[key] = value;
  }

  remove(key: string): void {
    delete this._storage[key];
  }
}