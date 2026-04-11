module Semantics where
-- Semantics = what each command actually *does* when it runs.
-- We walk the command list and update the Warehouse step by step.

import Syntax

-- Did execution succeed or fail?
data Outcome = Success Warehouse | Failure String

instance Show Outcome where
  show (Success w)   = "Success " ++ show w
  show (Failure msg) = "Failure: " ++ msg

-- ── Entry point ──────────────────────────────────────────────────────────────

runProgram :: Program -> Outcome
runProgram (Run cmds) = runAll cmds blankWarehouse

-- ── Run a list of commands ───────────────────────────────────────────────────

runAll :: Commands -> Warehouse -> Outcome
runAll []     wh = Success wh
runAll (c:cs) wh =
  case runOne c wh of
    Success updated -> runAll cs updated
    Failure msg     -> Failure msg

-- ── Run a single command ─────────────────────────────────────────────────────

runOne :: Command -> Warehouse -> Outcome

runOne (EnterMoto m) wh =
  let (catalog, riders, repairs) = wh
      updatedCatalog = (itemTag m, m) : catalog
  in Success (updatedCatalog, riders, repairs)

runOne (EnterRider r) wh =
  let (catalog, riders, repairs) = wh
      updatedRiders = (riderTag r, r) : riders
  in Success (catalog, updatedRiders, repairs)

runOne (LogRepair rt it note) wh =
  let (catalog, riders, repairs) = wh
      repairId       = length repairs + 1
      updatedRepairs = (repairId, (rt, it, note)) : repairs
  in Success (catalog, riders, updatedRepairs)

runOne (SetPrice it newCost) wh =
  let (catalog, riders, repairs) = wh
      updatedCatalog =
        map (\(tag, m) ->
               if tag == it
                 then (tag, m { cost = newCost })
                 else (tag, m))
            catalog
  in Success (updatedCatalog, riders, repairs)

runOne (SetQty it newQty) wh =
  let (catalog, riders, repairs) = wh
      updatedCatalog =
        map (\(tag, m) ->
               if tag == it
                 then (tag, m { qty = newQty })
                 else (tag, m))
            catalog
  in Success (updatedCatalog, riders, repairs)

runOne (SetAvail it newAvail) wh =
  let (catalog, riders, repairs) = wh
      updatedCatalog =
        map (\(tag, m) ->
               if tag == it
                 then (tag, m { avail = newAvail })
                 else (tag, m))
            catalog
  in Success (updatedCatalog, riders, repairs)

-- ── Empty starting state ─────────────────────────────────────────────────────

blankWarehouse :: Warehouse
blankWarehouse = ([], [], [])
