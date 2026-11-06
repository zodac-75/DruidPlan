-- DruidPlan data: the leveling plan, per level.
-- Text entries are either a plain string or { "English", "Svenska" }.
local _, ns = ...

-- Main professions until you pick or learn others.
ns.DEFAULT_PROFS = { "Alchemy", "Herbalism" }

-- Talent point per level: Feral (cat) leveling, 0/41/10 at 60.
-- Checked against the live tree (build 1.60.1.70790): every talent is taken only once
-- its row has 5 points per row spent in that tree, and Blood Frenzy (Sharpened Claws 2/2),
-- Rend and Tear (Predatory Strikes 3/3), Shifting Power (Predatory Discipline) and
-- Primal Bite (Leader of the Pack) come after what they need.
ns.talents = {
  [10] = "Ferocity 1/5", [11] = "Ferocity 2/5", [12] = "Ferocity 3/5",
  [13] = "Ferocity 4/5", [14] = "Ferocity 5/5",
  [15] = "Feral Swiftness 1/2", [16] = "Feral Swiftness 2/2",
  [17] = "Thick Hide 1/3", [18] = "Thick Hide 2/3", [19] = "Thick Hide 3/3",
  [20] = "Feral Charge 1/1",
  [21] = "Sharpened Claws 1/2", [22] = "Sharpened Claws 2/2",
  [23] = "Savage Fury 1/2", [24] = "Savage Fury 2/2",
  [25] = "Predatory Discipline 1/1",
  [26] = "Predatory Strikes 1/3", [27] = "Predatory Strikes 2/3", [28] = "Predatory Strikes 3/3",
  [29] = "Blood Frenzy 1/2",
  [30] = "Leader of the Pack 1/1",
  [31] = "Blood Frenzy 2/2",
  [32] = "Natural Instinct 1/2", [33] = "Natural Instinct 2/2",
  [34] = "Furor 1/5",
  [35] = "Rend and Tear 1/5", [36] = "Rend and Tear 2/5", [37] = "Rend and Tear 3/5",
  [38] = "Rend and Tear 4/5", [39] = "Rend and Tear 5/5",
  [40] = "Shifting Power 1/1",
  [41] = "Furor 2/5", [42] = "Furor 3/5", [43] = "Furor 4/5", [44] = "Furor 5/5",
  -- 45-54: Restoration for Strength in Cat Form (Heart of the Wild) and +10% damage (Naturalist).
  [45] = "Heart of the Wild 1/5", [46] = "Heart of the Wild 2/5", [47] = "Heart of the Wild 3/5",
  [48] = "Heart of the Wild 4/5", [49] = "Heart of the Wild 5/5",
  [50] = "Naturalist 1/5", [51] = "Naturalist 2/5", [52] = "Naturalist 3/5",
  [53] = "Naturalist 4/5", [54] = "Naturalist 5/5",
  [55] = "Shredding Attacks 1/3", [56] = "Shredding Attacks 2/3", [57] = "Shredding Attacks 3/3",
  [58] = "Primal Bite 1/1",
  [59] = "Feral Instinct 1/3", [60] = "Feral Instinct 2/3",
}

-- Quests, gear and consumables worth knowing about at the level.
ns.gear = {
  [10] = { { "Bear Form: class quest The Great Ursera Spirit (Zephras Isle)", "Bear Form: klassquesten The Great Ursera Spirit (Zephras Isle)" },
           { "Elixir of Minor Agility (Alchemy)", "Elixir of Minor Agility (Alchemy)" } },
  [20] = { { "Cat Form: class quest from your druid trainer", "Cat Form: klassquest hos din druid-trainer" },
           { "Polearms can be trained now (Woo Ping, Stormwind)", "Polearms kan tränas nu (Woo Ping, Stormwind)" },
           { "Elixir of Ogre Strength (Alchemy)", "Elixir of Ogre Strength (Alchemy)" } },
  [30] = { { "Travel Form: about mount speed outdoors", "Travel Form: ungefär mount-fart utomhus" } },
  [35] = { { "Elixir of Agility (Alchemy)", "Elixir of Agility (Alchemy)" } },
  [40] = { { "Elixir of Greater Agility (Alchemy)", "Elixir of Greater Agility (Alchemy)" } },
  [50] = { { "Elixir of the Mongoose (Alchemy 290+)", "Elixir of the Mongoose (Alchemy 290+)" } },
}

-- Spells to train (exact spell names, so the addon can check what you already know).
ns.spells = {
  [4]  = { "Moonfire", "Rejuvenation" },
  [6]  = { "Thorns" },
  [8]  = { "Entangling Roots" },
  [10] = { "Nature's Grasp", "Teleport: Moonglade" },
  [12] = { "Regrowth", "Revive" },
  [14] = { "Cure Poison" },
  [18] = { "Faerie Fire", "Hibernate" },
  [20] = { "Rebirth", "Starfire" },
  [24] = { "Ferocious Bite", "Rake", "Remove Curse" },
  [26] = { "Abolish Poison" },
  [28] = { "Cower" },
  [30] = { "Travel Form", "Tranquility" },
  [32] = { "Ravage" },
  [36] = { "Pounce", "Frenzied Regeneration" },
  [40] = { "Dire Bear Form", "Hurricane" },
  [44] = { "Barkskin" },
  [50] = { "Gift of the Wild" },
}

-- Profession goals: at this level you want at least this skill.
ns.profTargets = {
  { level = 10, skill = 50,  note = { "Train Journeyman (Sylvanna Forestmoon, Darnassus)", "Träna Journeyman (Sylvanna Forestmoon, Darnassus)" } },
  { level = 20, skill = 125, note = { "Train Expert (Ainethil, Darnassus)", "Träna Expert (Ainethil, Darnassus)" } },
  { level = 35, skill = 200, note = { "Train Artisan (Kylanna Windwhisper, Feathermoon, Feralas)", "Träna Artisan (Kylanna Windwhisper, Feathermoon, Feralas)" } },
  { level = 50, skill = 260, note = { "Keep pace towards 300", "Håll takten mot 300" } },
  { level = 58, skill = 300, note = { "300 for Elixir of the Mongoose", "300 för Elixir of the Mongoose" } },
}
