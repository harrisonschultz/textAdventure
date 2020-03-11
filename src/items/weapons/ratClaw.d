module items.weapons.ratClaw;

import items.weapons.weapon;
import types.damage;
import items.weapons.attack;

class RatClaw : Weapon
{

   this()
   {
      damage = 1;
      attacks = [swipe];
   }
}

public Attack swipe = {name: "swipe", damageModifier: 1, damageType: DamageTypes.slash};