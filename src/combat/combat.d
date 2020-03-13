module combat.combat;

import characters.character;
import items.weapons.weapon;
import details.stats;
import std.math;
import std.conv;
import state.state;
import std.format;
import std.ascii;
import std.stdio;
import characters.player;
import combat.ai;

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

   static deathText(State* state)
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

   static Player setRewards(State* state)
   {
      Player player = Stats.addExp(state.player, state.enemy.expReward);
      return player;
   }

   static Player playerKilled(Player player)
   {
      player.renew();
      return player;
   }
}
