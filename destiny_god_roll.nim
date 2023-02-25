import math, strformat

type 
  Odds = object
    x, outOf: int

proc `$`(this: Odds): string =
  fmt"{this.x} in {this.outOf} ({100 * this.x/this.outOf:.2f}%)"

proc `*`(this: Odds, odds: Odds): Odds =
  return Odds(x: this.x * odds.x, outOf: this.outOf * odds.outOf)

# permutations, order matters
proc permutations(n: int, pick: int): int =
  fac(n) div (fac(n - pick))

# combinations, order does not matter, need to remove redundant/same results
proc combinations(n: int, choose: int): int =
  fac(n) div (fac(n - choose) * fac(choose))

proc goodRollChance(totalPerks: int, columnSlots, goodPerks: int): Odds =
  let totalCombinations = combinations(totalPerks, columnSlots)
  let badCombinations = combinations(totalPerks - goodPerks, columnSlots)

  if(badCombinations <= 0):
    return Odds(x: totalCombinations, outOf: totalCombinations)

  let goodCombinations = totalCombinations - badCombinations

  return Odds(x: goodCombinations, outOf: totalCombinations)

when isMainModule:
  # https://www.light.gg/db/items/555148853/wendigo-gl3-adept/
  let barrels = goodRollChance(7, 2, 1)  # quick launch (not hard launch)
  let magazine = goodRollChance(7, 2, 1) # spike grenades
  let perk1 = goodRollChance(6, 2, 1)    # auto loading holster
  let perk2 = goodRollChance(6, 1, 1)    # explosive light

  echo "Wendigo GL3"
  echo fmt"Quick Launch: {barrels}"
  echo fmt"Spike Grenades: {magazine}"
  echo fmt"Auto Loading Holster: {perk1}"
  echo fmt"Explosive Light: {perk2}"
  echo fmt"ALH + Explosive Light = {(perk1 * perk2)}"
  echo fmt"Spike + ALH + Explosive Light = {(magazine * perk1 * perk2)}"
  echo fmt"Quick Launch + Spike + ALH + Explosive Light = {(barrels * magazine * perk1 * perk2)}"