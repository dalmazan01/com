{--
Context Free Grammar

Name: MotoTrack
Description:
    MotoTrack is a management language for motorcycle dealerships.
    Staff can track inventory, registered riders, and repair requests.
    Every record is identified by a unique numeric tag.
    Only motorcycles are supported — each one has a brand.

---- GRAMMAR ----

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
<note>      -> String

<item_tag>  -> Int
<rider_tag> -> Int

---- ENVIRONMENTS ----

<catalog_env> -> [(<item_tag>,  <moto_info>)]
<rider_env>   -> [(<rider_tag>, <rider>)]
<repair_env>  -> [(<repair_id>, (<rider_tag>, <item_tag>, <note>))]

---- EXAMPLE DERIVATIONS ----

-- Example 1: Adding a Yamaha motorcycle (tag 201)
--
-- <program>
--   => <cmd_list>
--   => <cmd>
--   => EnterMoto <moto_info>
--   => EnterMoto "tag: " <item_tag> "brand: " <brand> "yr: " Int
--                "cost: " Float "qty: " Int "avail: " Bool
--   => EnterMoto "tag: " 201 "brand: " "Yamaha" "yr: " 2024
--                "cost: " 9750.00 "qty: " 4 "avail: " True

-- Example 2: Registering a rider (rider_tag 10)
--
-- <program>
--   => <cmd_list>
--   => <cmd>
--   => EnterRider <rider>
--   => EnterRider "rider_tag: " <rider_tag> "alias: " String "contact: " String
--   => EnterRider "rider_tag: " 10 "alias: " "Sam Torres" "contact: " "361-555-0210"

-- Example 3: A two-command program — add a Honda then update its price
--
-- <program>
--   => <cmd_list>
--   => <cmd> <cmd_list>
--   => EnterMoto <moto_info>  <cmd>
--   => EnterMoto "tag: " 202 "brand: " "Honda" "yr: " 2023
--                "cost: " 8400.00 "qty: " 3 "avail: " True
--      SetPrice <item_tag> Float
--   => EnterMoto ... SetPrice 20290.00

--}
