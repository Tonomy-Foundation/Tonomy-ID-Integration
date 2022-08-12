// TODO use @greymass/eosio instead of eosjs
import { Api, JsonRpc } from "eosjs";
import { JsSignatureProvider } from "eosjs/dist/eosjs-jssig"
import fetch from "node-fetch"; // node only; not needed in browsers
import { TextEncoder, TextDecoder } from "util"; // node only; native TextEncoder/Decoder
import { PrivateKey } from "@greymass/eosio";

const privateKey = "PVT_K1_2bfGi9rYsXQSXXTvJbDAPhHLQUojjaNLomdm3cEJ1XTzMqUt3V";
const publicKey = PrivateKey.from(privateKey).toPublic();
// PUB_K1_6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5BoDq63

const signatureProvider = new JsSignatureProvider([privateKey]);

const rpc = new JsonRpc("http://localhost:8888", { fetch })
const api = new Api({
    rpc,
    signatureProvider,
    textDecoder: new TextDecoder(),
    textEncoder: new TextEncoder(),
})

export { api, publicKey };