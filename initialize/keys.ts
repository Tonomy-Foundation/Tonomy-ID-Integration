import { PrivateKey } from "@greymass/eosio";
import { EosioUtil } from "tonomy-id-sdk";

const privateKey = PrivateKey.from("PVT_K1_2bfGi9rYsXQSXXTvJbDAPhHLQUojjaNLomdm3cEJ1XTzMqUt3V");
const publicKey = privateKey.toPublic();
// PUB_K1_6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5BoDq63
const signer = EosioUtil.createSigner(privateKey)

export { privateKey, publicKey, signer };