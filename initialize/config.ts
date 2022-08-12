import { Api, JsonRpc, JsSignatureProvider } from "eosjs";
import fetch from "node-fetch"; // node only; not needed in browsers
import { TextEncoder, TextDecoder } from "util"; // node only; native TextEncoder/Decoder

const signatureProvider = new JsSignatureProvider([
    `5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3`,
    /* other private keys for your contract account */,
]);

const rpc = new JsonRpc("http://localhost:8888", { fetch })
const api = new Api({
    rpc,
    signatureProvider,
    textDecoder: new TextDecoder(),
    textEncoder: new TextEncoder(),
})


module.exports = {
    api
}