module items.weapons.rustedSword;

import items.weapons.weapon;
import types.damage;
import items.weapons.attack;
import types.item;

class RustedSword : Weapon
{

   this()
   {
      type = ItemType.weapon;
      value = 10;
      damage = 2;
      attacks = [slash];
      name = "Rusted Sword";
   }
}

public Attack slash = {name: "Slash", damageModifier: 1, damageType: DamageTypes.slash};