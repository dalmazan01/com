module Syntax where

{-
MotoTrack — motorcycle dealership management language

Context Free Grammar

<program>   -> <cmd_list>
<cmd_list>  -> <cmd> | <cmd> <cmd_list>

<cmd> -> EnterMoto  <moto_info>
       | EnterRider <rider>
       | LogRepair  <rider_tag> <item_tag> <note>
       | SetPrice   <item_tag> Float
       | SetQty     <item_tag> Int
       | SetAvail   <item_tag> Bool

<moto_info> -> "tag: " <item_tag>  "brand: " <brand>  "yr: " Int
               "cost: " Float  "qty: " Int  "avail: " Bool
<brand>     -> "Yamaha" | "Suzuki" | "Honda" | "Kawasaki" | "Harley-Davidson"
<rider>     -> "rider_tag: " <rider_tag>  "alias: " String  "contact: " String
<item_tag>  -> Int
<rider_tag> -> Int
-}

-- Top-level program: a sequence of commands
data Program = Run Commands

type Commands = [Command]

-- Every action the user can issue
data Command
  = EnterMoto  MotoInfo
  | EnterRider Rider
  | LogRepair  Int Int String   -- rider_tag, item_tag, note
  | SetPrice   Int Float        -- item_tag, new price
  | SetQty     Int Int          -- item_tag, new quantity
  | SetAvail   Int Bool         -- item_tag, available?

-- Supported motorcycle brands
data Brand
  = Yamaha
  | Suzuki
  | Honda
  | Kawasaki
  | HarleyDavidson
  deriving (Eq)

-- A motorcycle record stored in the catalog
data MotoInfo = MotoInfo
  { itemTag    :: Int
  , brand      :: Brand
  , modelYear  :: Int
  , cost       :: Float
  , qty        :: Int
  , avail      :: Bool
  , repairNote :: String
  }

-- A registered rider
data Rider = Rider
  { riderTag :: Int
  , alias    :: String
  , contact  :: String
  }

-- Convenience aliases
type ItemTag  = Int
type RiderTag = Int

-- Storage environments
type CatalogEnv = [(Int, MotoInfo)]              -- motorcycles by item tag
type RiderEnv   = [(Int, Rider)]                  -- riders by rider tag
type RepairEnv  = [(Int, (Int, Int, String))]     -- repairs: id -> (rider_tag, item_tag, note)

-- All three environments bundled together
--type Warehouse = (CatalogEnv, RiderEnv, RepairEnv)
data Warehouse = W {
  catalog_env :: CatalogEnv,
  rider_env :: RiderEnv,
  repair_env :: RepairEnv
}

-- initial env
iEnv = W [] [] []
-- ── Show instances ───────────────────────────────────────────────────────────

instance Show Brand where
  show Yamaha        = "Yamaha"
  show Suzuki        = "Suzuki"
  show Honda         = "Honda"
  show Kawasaki      = "Kawasaki"
  show HarleyDavidson = "Harley-Davidson"

instance Show MotoInfo where
  show m =
    "MotoInfo (tag="   ++ show (itemTag m)   ++
    ", brand="   ++ show (brand m)            ++
    ", year="    ++ show (modelYear m)        ++
    ", cost="    ++ show (cost m)             ++
    ", qty="     ++ show (qty m)              ++
    ", avail="   ++ show (avail m)            ++
    ", note="    ++ repairNote m              ++ ")"

instance Show Rider where
  show r =
    "Rider (tag="      ++ show (riderTag r) ++
    ", alias="   ++ alias r                  ++
    ", contact=" ++ contact r                ++ ")"

instance Show Command where
  show (EnterMoto m)       = "EnterMoto "  ++ show m
  show (EnterRider r)      = "EnterRider " ++ show r
  show (LogRepair rt it nt) =
    "LogRepair (riderTag=" ++ show rt ++
    ", itemTag="  ++ show it ++
    ", note="     ++ nt      ++ ")"
  show (SetPrice it p)     = "SetPrice item=" ++ show it ++ " to " ++ show p
  show (SetQty   it q)     = "SetQty   item=" ++ show it ++ " to " ++ show q
  show (SetAvail it a)     = "SetAvail item=" ++ show it ++ " to " ++ show a

instance Show Program where
  show (Run cmds) = unlines (map show cmds)
