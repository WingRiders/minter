{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE NoImplicitPrelude #-}

module FixedSupplyPolicy
  ( fixedSupplyPolicy,
    fixedSupplyCurrencySymbol,
  )
where

import Ledger
import Ledger.Typed.Scripts as Scripts
import Ledger.Value (flattenValue)
import PlutusTx
import PlutusTx.Prelude

-- |
--  A fixed supply minting policy. The policy expects the number of tokens
--  to be minted as a redeemer. The policy ID is unique and can only be
--  used if a given UTxO is used on the input. This means that no additional
--  tokens can be minted and the minted tokens cannot be burned.
--  
--  Note: there is a special use-case, if exactly 1 token is minted,
--  the minting policy acts as an NFT minter. For it to be a valid NFT,
--  the transaction should also include correct metadata according to
--  CIP-0025
{-# INLINEABLE fixedSupplyPolicyScript #-}
fixedSupplyPolicyScript :: TxOutRef -> Integer -> ScriptContext -> Bool
fixedSupplyPolicyScript oref amount ctx =
  traceIfFalse "UTxO not spent" (isJust $ findTxInByTxOutRef oref info)
    && traceIfFalse "wrong amount minted" checkMintedAmount
  where
    info :: TxInfo
    info = scriptContextTxInfo ctx

    checkMintedAmount :: Bool
    checkMintedAmount = case flattenValue (txInfoMint info) of
      [(cs, _, amt)] -> cs == ownCurrencySymbol ctx && amt == amount
      _ -> False

fixedSupplyPolicy :: TxOutRef -> Scripts.MintingPolicy
fixedSupplyPolicy oref =
  mkMintingPolicyScript $
    $$(PlutusTx.compile [||Scripts.wrapMintingPolicy . fixedSupplyPolicyScript||])
      `PlutusTx.applyCode` PlutusTx.liftCode oref

fixedSupplyCurrencySymbol :: TxOutRef -> CurrencySymbol
fixedSupplyCurrencySymbol = scriptCurrencySymbol . fixedSupplyPolicy
