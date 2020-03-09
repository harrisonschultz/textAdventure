module items.weapons.unarmed;
import items.weapons.weapon;
import types.damage;

class Unarmed : Weapon {

   this () {
      damageType = DamageTypes.blunt;
      damage = 1;
   }
}