module Examples where

import Syntax
import Semantics

-- ── Sample motorcycles ───────────────────────────────────────────────────────

moto1 :: MotoInfo
moto1 = MotoInfo
  { itemTag    = 201
  , brand      = Yamaha
  , modelYear  = 2024
  , cost       = 9750.00
  , qty        = 4
  , avail      = True
  , repairNote = "Ready to sell"
  }

moto2 :: MotoInfo
moto2 = MotoInfo
  { itemTag    = 202
  , brand      = Honda
  , modelYear  = 2023
  , cost       = 8400.00
  , qty        = 3
  , avail      = True
  , repairNote = "Minor tune-up done"
  }

moto3 :: MotoInfo
moto3 = MotoInfo
  { itemTag    = 203
  , brand      = HarleyDavidson
  , modelYear  = 2022
  , cost       = 17500.00
  , qty        = 2
  , avail      = False
  , repairNote = "Awaiting brake parts"
  }

moto4 :: MotoInfo
moto4 = MotoInfo
  { itemTag    = 204
  , brand      = Kawasaki
  , modelYear  = 2024
  , cost       = 11200.00
  , qty        = 5
  , avail      = True
  , repairNote = "New arrival"
  }

moto5 :: MotoInfo
moto5 = MotoInfo
  { itemTag    = 205
  , brand      = Suzuki
  , modelYear  = 2023
  , cost       = 7800.00
  , qty        = 6
  , avail      = True
  , repairNote = "Good condition"
  }

-- ── Sample riders ────────────────────────────────────────────────────────────

rider1 :: Rider
rider1 = Rider
  { riderTag = 10
  , alias    = "Sam Torres"
  , contact  = "361-555-0210"
  }

rider2 :: Rider
rider2 = Rider
  { riderTag = 11
  , alias    = "Casey Rivera"
  , contact  = "361-555-0311"
  }

-- ── Individual commands ──────────────────────────────────────────────────────

cmd1 :: Command
cmd1 = EnterMoto moto1             -- add Yamaha

cmd2 :: Command
cmd2 = EnterMoto moto2             -- add Honda

cmd3 :: Command
cmd3 = EnterMoto moto3             -- add Harley-Davidson

cmd4 :: Command
cmd4 = EnterRider rider1           -- register Sam

cmd5 :: Command
cmd5 = EnterRider rider2           -- register Casey

cmd6 :: Command
cmd6 = SetPrice 201 10500.00       -- bump Yamaha price

cmd7 :: Command
cmd7 = SetQty 202 6                -- restock Honda

cmd8 :: Command
cmd8 = LogRepair 10 203 "Brake pads worn — parts ordered"  -- Sam's repair ticket

cmd9 :: Command
cmd9 = SetAvail 203 True           -- Harley back in service

-- ── Programs ─────────────────────────────────────────────────────────────────

-- Program A: stock three bikes and two riders
progA :: Program
progA = Run [cmd1, cmd2, cmd3, cmd4, cmd5]

-- Program B: add Yamaha, update price, log a repair, reactivate Harley
progB :: Program
progB = Run [cmd1, cmd3, cmd6, cmd8, cmd9]

-- Program C: full dealership workflow across all five brands
progC :: Program
progC = Run [ EnterMoto moto1, EnterMoto moto2, EnterMoto moto3
            , EnterMoto moto4, EnterMoto moto5
            , EnterRider rider1, EnterRider rider2
            , cmd7, cmd8, cmd9 ]

-- ── Main ─────────────────────────────────────────────────────────────────────

main :: IO ()
main = do
  putStrLn "=== Cmd 1: Add Yamaha ==="
  print cmd1
  putStrLn ""

  putStrLn "=== Cmd 2: Add Honda ==="
  print cmd2
  putStrLn ""

  putStrLn "=== Cmd 3: Add Harley-Davidson ==="
  print cmd3
  putStrLn ""

  putStrLn "=== Cmd 4: Register Rider Sam ==="
  print cmd4
  putStrLn ""

  putStrLn "=== Cmd 5: Register Rider Casey ==="
  print cmd5
  putStrLn ""

  putStrLn "=== Cmd 6: Update Yamaha Price ==="
  print cmd6
  putStrLn ""

  putStrLn "=== Cmd 7: Restock Honda ==="
  print cmd7
  putStrLn ""

  putStrLn "=== Cmd 8: Log Repair Ticket ==="
  print cmd8
  putStrLn ""

  putStrLn "=== Cmd 9: Mark Harley Available ==="
  print cmd9
  putStrLn ""

  putStrLn "─── Program A: Stock bikes + riders ───"
  print (runProgram progA)
  putStrLn ""

  putStrLn "─── Program B: Price update + repair workflow ───"
  print (runProgram progB)
  putStrLn ""

  putStrLn "─── Program C: Full dealership workflow ───"
  print (runProgram progC)
