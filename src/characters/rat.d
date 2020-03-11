module characters.rat;

import items.weapons.ratClaw;
import items.armors.ratHide;
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

    gear.weapon = new RatClaw();
    gear.chest = new RatHide();
  }

}
