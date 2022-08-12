import { Api, JsonRpc } from "eosjs";
import { JsSignatureProvider } from "eosjs/dist/eosjs-jssig"
import fetch from "node-fetch"; // node only; not needed in browsers
import { TextEncoder, TextDecoder } from "util"; // node only; native TextEncoder/Decoder

const signatureProvider = new JsSignatureProvider([
    `5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3`,
]);

const rpc = new JsonRpc("http://localhost:8888", { fetch })
const api = new Api({
    rpc,
    signatureProvider,
    textDecoder: new TextDecoder(),
    textEncoder: new TextEncoder(),
})

export { api };