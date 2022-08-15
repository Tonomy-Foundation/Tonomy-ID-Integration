// https://medium.com/coinmonks/setcode-and-setabi-with-eos-js-dd83480ba234

import fs from "fs";
import path from "path";
import { ABI, Name, Serializer, Checksum256 } from '@greymass/eosio';
import { EosioUtil } from 'tonomy-id-sdk';
const { transact, privateKey } = EosioUtil;

const signer = {
    sign(digest: Checksum256) {
        return privateKey.signDigest(digest);
    }
}

function getDeployableFilesFromDir(dir) {
    const dirCont = fs.readdirSync(dir)

    const wasmFileName = dirCont.find(filePath => filePath.match(/.*\.(wasm)$/gi))
    const abiFileName = dirCont.find(filePath => filePath.match(/.*\.(abi)$/gi))
    if (!wasmFileName) throw new Error(`Cannot find a ".wasm file" in ${dir}`)
    if (!abiFileName) throw new Error(`Cannot find an ".abi file" in ${dir}`)

    return {
        wasmPath: path.join(dir, wasmFileName),
        abiPath: path.join(dir, abiFileName),
    }
}

async function deployContract({ account, contractDir }) {
    const { wasmPath, abiPath } = getDeployableFilesFromDir(contractDir)

    // 1. Prepare SETCODE
    // read the file and make a hex string out of it
    const wasm = fs.readFileSync(wasmPath).toString(`hex`);

    // 2. Prepare SETABI
    const abi = JSON.parse(fs.readFileSync(abiPath, `utf8`))
    const abiDef = ABI.from(abi);
    const abiSerializedHex = Serializer.encode({ object: abiDef }).hexString;

    // 3. Send transaction with both setcode and setabi actions
    console.log(`Deploying contract to ${account}`);
    const actions = [
        {
            account: 'eosio',
            name: 'setcode',
            authorization: [
                {
                    actor: account,
                    permission: 'active',
                },
            ],
            data: {
                account: account,
                vmtype: 0,
                vmversion: 0,
                code: wasm,
            },
        },
        {
            account: 'eosio',
            name: 'setabi',
            authorization: [
                {
                    actor: account,
                    permission: 'active',
                },
            ],
            data: {
                account: account,
                abi: abiSerializedHex,
            },
        },
    ]
    await transact(Name.from("eosio"), actions, signer);
}

export default deployContract;