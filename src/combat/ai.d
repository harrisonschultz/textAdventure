module combat.ai;

import characters.character;
import characters.player;
import actions.action;
import std.conv;
import std.random;

class AI
{
   static int chooseAttack(Character enemy, Player player)
   {
      if (enemy.gear.weapon.attacks.length == 1)
      {
         return 0;
      }
      else
      {
         ulong attackIndex = uniform(0, enemy.gear.weapon.attacks.length - 1);
         return to!int(attackIndex);
      }
   }
}
