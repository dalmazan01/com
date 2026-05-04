module Semantics where
-- Semantics = what each command actually *does* when it runs.
-- We walk the command list and update the Warehouse step by step.

import Syntax

-- Did execution succeed or fail?
data Outcome = Success Warehouse | Failure String

instance Show Outcome where
  show (Success w)   = "Success " ++ show w
  show (Failure msg) = "Failure: " ++ msg

instance Show Warehouse where
  show w =
    "Warehouse { catalog=" ++ show (catalog_env w) ++
    ", riders="  ++ show (rider_env w)              ++
    ", repairs=" ++ show (repair_env w)             ++ " }"

-- ── Entry point ──────────────────────────────────────────────────────────────

runProgram :: Program -> Outcome
runProgram (Run cmds) = runAll cmds iEnv

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
  let updatedCatalog = (itemTag m, m) : catalog_env wh
  in Success wh { catalog_env = updatedCatalog }

runOne (EnterRider r) wh =
  let updatedRiders = (riderTag r, r) : rider_env wh
  in Success wh { rider_env = updatedRiders }

runOne (LogRepair rt it note) wh =
  let repairId       = length (repair_env wh) + 1
      updatedRepairs = (repairId, (rt, it, note)) : repair_env wh
  in Success wh { repair_env = updatedRepairs }

runOne (SetPrice it newCost) wh =
  let updatedCatalog =
        map (\(tag, m) ->
               if tag == it
                 then (tag, m { cost = newCost })
                 else (tag, m))
            (catalog_env wh)
  in Success wh { catalog_env = updatedCatalog }

runOne (SetQty it newQty) wh =
  let updatedCatalog =
        map (\(tag, m) ->
               if tag == it
                 then (tag, m { qty = newQty })
                 else (tag, m))
            (catalog_env wh)
  in Success wh { catalog_env = updatedCatalog }

runOne (SetAvail it newAvail) wh =
  let updatedCatalog =
        map (\(tag, m) ->
               if tag == it
                 then (tag, m { avail = newAvail })
                 else (tag, m))
            (catalog_env wh)
  in Success wh { catalog_env = updatedCatalog }