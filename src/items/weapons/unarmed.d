module items.weapons.unarmed;
import items.weapons.weapon;
import types.damage;
import items.weapons.attack;

class Unarmed : Weapon
{

   this()
   {
      damage = 1;
      attacks = [jab];
      name = "Unarmed";
   }
}

public Attack jab = {name: "Jab", damageModifier: 1, damageType: DamageTypes.blunt};