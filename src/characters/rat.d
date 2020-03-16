module characters.rat;

import items.weapons.ratClaw;
import items.armors.ratHide;
import items.item;
import items.loot;
import items.trash.ratFur;
import characters.character;

class Rat : Character
{

  this()
  {
    attr["str"] = 1;
    attr["dex"] = 1;
    attr["per"] = 1;
    attr["mnd"] = 1;
    attr["con"] = 1;

    health = Stats.getMaxHealth(this);

    gear.weapon = new RatClaw();
    gear.chest = new RatHide();

    description = "A rat, disease striken. Lives and breathes in filth.";
    expReward = 1;

    loot = [new Loot(new RatFur(), 33)];
  }
}
