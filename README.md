# Fixed Supply Minting

A fixed supply minting policy. The policy expects the number of tokens
to be minted as a redeemer. The policy ID is unique and can only be
used if a given UTxO is used on the input. This means that no additional
tokens can be minted and the minted tokens cannot be burned.

Note: there is a special use-case, if exactly 1 token is minted,
the minting policy acts as an NFT minter. For it to be a valid NFT,
the transaction should also include correct metadata according to
[CIP-0025](https://github.com/cardano-foundation/CIPs/blob/master/CIP-0025/README.md).

## Deployment

The script is used through the frontend on https://minter.wingriders.com
functioning both on the testnet and mainnet.

## Metadata

Currently PlutusV1 does not have support to checking metadata. After the tokens were minted, to add metadata you will have to add them manually by creating a pull request at a github repository: [mainnet](https://github.com/cardano-foundation/cardano-token-registry) or [testnet](https://github.com/input-output-hk/metadata-registry-testnet). The process is [here](https://github.com/cardano-foundation/cardano-token-registry/wiki/How-to-prepare-an-entry-for-the-registry-%28Plutus-script%29#step-2-prepare-a-draft-entry).

## Artifact

The artifact `fixed-supply-policy.plutus` was generated using a template UTxO:

```
deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef#0
```

For building it the following versions were used:

- [plutus-apps](https://github.com/input-output-hk/plutus-apps) tag: 34fe6eeff441166fee0cd0ceba68c1439f0e93d2
- [plutus](https://github.com/input-output-hk/plutus) tag: 65bad0fd53e432974c3c203b1b1999161b6c2dce
