module details.stats;

import items.weapons.weapon;
import items.weapons.attack;
import characters.character;
import characters.player;
import types.damage;
import types.armor;
import std.conv;
import std.math;
import std.stdio;

class Stats
{
public:

   static short getMaxHealth(Character character)
   {
      double[string] healthModifiers = ["str" : 1, "dex" : 0.4, "con" : 2];

      return to!short(round(modifyNumber(1, healthModifiers, character)));
   }

   static float calcAttackDamage(Weapon weapon, int attackIndex, Character character)
   {
      float dmg = 0;

      auto damageModifiers = [
         DamageTypes.slash : ["str" : 0.75, "dex" : 1, "con" : 0.25],
         DamageTypes.blunt : ["str" : 1.25, "dex" : 0, "con" : 0.5]
      ];
      
      dmg = modifyNumber(weapon.damage * weapon.attacks[attackIndex].damageModifier,
            damageModifiers[weapon.attacks[attackIndex].damageType], character);

      return dmg;
   }

   static Player addExp(Player character, short exp) {
      character.exp += exp;

      return character;
   }

   static Player addLevel(Player character) {
      character.level += 1;
      character.openAttrPoints += 2;
      character.openSkillPoints += 2;
      return character;
   }

   static Player handleExp(Player character, short exp) {
      short maxExp = getMaxExp(character);
      character = addExp(character, exp);
      // level exp threshold is reached
      if (character.exp >= maxExp) {
         character.exp -= maxExp;
         character = addLevel(character);
      }
      return character;
   }

   static short getMaxExp(Character character) {
      short base = 10;
      double exponentialGain = 1.25;
      double expNeeded = pow(character.level, exponentialGain) * base;

      // Each point of intelligence reduces exp needed by 1%
      double expReduction = (character.attr["mnd"] / 100) * expNeeded;

      return to!short(round(expNeeded - expReduction));
   }

   static float calcPreventedDamage(Weapon weapon, int attackIndex, Character character)
   {
      float dmgPrevented = 0;

      auto defenseModifiers = [
         DamageTypes.slash : [
            ArmorTypes.plate : 0.2, ArmorTypes.mail : 0.3, ArmorTypes.fabric : 0.05
         ],
         DamageTypes.blunt : [
            ArmorTypes.plate : 0.25, ArmorTypes.mail : 0.1, ArmorTypes.fabric : 0.05
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
