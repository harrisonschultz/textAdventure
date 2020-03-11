module details.stats;

import items.weapons.weapon;
import characters.character;
import types.damage;
import items.weapons.attack;
import types.armor;

class Stats
{
public:
   // static const(double[string]) healthModifiers = [
   //    "str" : 1, "dex" : 0.4, "con" : 2
   // ];

   static float calcAttackDamage(Weapon weapon, short attackIndex, Character character)
   {
      float dmg = 0;

      auto damageModifiers = [
      DamageTypes.slash : ["str" : 1, "dex" : 1, "con" : 0.25]
   ];

      dmg = modifyNumber(weapon.damage * weapon.attacks[attackIndex].damageModifier,
            damageModifiers[weapon.attacks[attackIndex].damageType], character);

      return dmg;
   }

   static float calcPreventedDamage(Weapon weapon, short attackIndex, Character character)
   {
      float dmgPrevented = 0;

       auto defenseModifiers = [
      DamageTypes.slash : [
         ArmorTypes.plate : 0.2, ArmorTypes.mail : 0.3, ArmorTypes.fabric : 0.05
      ]
   ];

      dmgPrevented = defenseModifiers[weapon.attacks[attackIndex].damageType][character
         .gear.chest.armorType] * character.gear.chest.armor;

      return dmgPrevented;
   }

   static double modifyNumber(double base, double[string] modifiers, Character character)
   {
      double num = base;
      foreach (key, value; modifiers)
      {
         num += (value * character.attr[key]);
      }
      return num;
   }
}
