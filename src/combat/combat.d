module combat.combat;

import characters.character;
import items.weapons.weapon;
import details.stats;
import std.math;
import std.random;
import std.conv;
import state.state;
import std.format;
import std.ascii;
import std.stdio;
import characters.player;
import combat.ai;
import items.item;
import items.loot;
import std.array;

class Combat
{

   static short attack(Character victim, Character attacker, int attackIndex)
   {
      double damage = 0;

      double incomingDamage = Stats.calcAttackDamage(attacker.gear.weapon, attackIndex, attacker);
      double mitigatedDamage = Stats.calcPreventedDamage(attacker.gear.weapon, attackIndex, victim);

      damage = incomingDamage - mitigatedDamage;

      // Damage cannot heal you lol
      if (damage < 0)
      {
         damage = 0;
      }

      return to!short(round(damage));
   }

   static string combatRewardText(State* state)
   {
      if (state.enemy.health <= 0)
      {
         return format("Victory!\n All enemies were defeated.\n\nExp gained %s\nProgress      %s / %s\nLoot\n",
               state.enemy.expReward, state.player.exp, Stats.getMaxExp(state.player));
      }

      return "";
   }

   static string deathText(State* state)
   {
      return "You died. You are resurrected by an unknown source.";
   }

   static short enemyAction(Character enemy, Player player)
   {
      double damage = 0;
      int attackIndex = AI.chooseAttack(enemy, player);

      double incomingDamage = Stats.calcAttackDamage(enemy.gear.weapon, attackIndex, enemy);
      double mitigatedDamage = Stats.calcPreventedDamage(enemy.gear.weapon, attackIndex, player);

      damage = incomingDamage - mitigatedDamage;

      // Damage cannot heal you lol
      if (damage < 0)
      {
         damage = 0;
      }

      return to!short(round(damage));
   }

   static void setRewards(State* state)
   {
      Stats.handleExp(state.player, state.enemy.expReward);
      state.player.inventory = join([state.player.inventory, findLoot(state.enemy)]);
   }

   static Item[] findLoot(Character enemy) {
      Item[] found;

      foreach (loot; enemy.loot) {
         int roll = uniform(0, 100);
         if (roll <= loot.dropChance) {
            found ~= loot.item;
         }
      }

      return found;
   }

   static Player playerKilled(Player player)
   {
      player.renew();
      return player;
   }
}
