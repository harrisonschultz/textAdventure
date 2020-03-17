module engine;

import state.state;
import locations.location;
import types.menus;
import combat.combat;
import std.conv;
import std.stdio;
import shops.shop;

class Engine
{
   static void moveSelectionDown(State* state)
   {
      ulong cap = getCap(state);

      if (state.menu == Menus.shop && state.selectedAction == state.location.shop.items.length + state.player.inventory.length - 1) {
          state.selectedAction = to!int(state.location.shop.items.length);
      } else {
         state.selectedAction++;
      }

      if (state.selectedAction + 1 > cap)
      {
         state.selectedAction = 0;
      }
   };

   static void moveSelectionUp(State* state)
   {
      ulong cap = getCap(state);

      if (state.menu == Menus.shop && state.selectedAction == state.location.shop.items.length) {
          state.selectedAction = to!int(state.location.shop.items.length + state.player.inventory.length - 1);
      } else {
         state.selectedAction--;
      }

      if (state.selectedAction < 0)
      {
         state.selectedAction = to!int(cap) - 1;
      }
   };

   static void moveSelectionLeft(State* state)
   {
      if (state.menu == Menus.shop) {
         ulong buyLength = state.location.shop.items.length;
         ulong sellLength = state.player.inventory.length;

         // If either menu is empty, dis allow movement;
         if (sellLength == 0) {
            return;
         } else if (buyLength == 0) {
            return;
         }

         // if you press right when you are at the right most.
         if (state.selectedAction < buyLength) {
            state.selectedAction += to!int(buyLength);
            if (state.selectedAction > buyLength + sellLength - 1) {
               state.selectedAction = to!int(buyLength);
            }
         }
         else {
            state.selectedAction -= to!int(buyLength);
            if (state.selectedAction > buyLength - 1) {
               state.selectedAction = 0;
            }
         }
      }
   };

   static void moveSelectionRight(State* state)
   {
      if (state.menu == Menus.shop) {
         ulong buyLength = state.location.shop.items.length;
         ulong sellLength = state.player.inventory.length;

         // If either menu is empty, dis allow movement;
         if (sellLength == 0) {
            return;
         } else if (buyLength == 0) {
            return;
         }

         // if you press right when you are at the right most.
         if (state.selectedAction > buyLength -1) {
            state.selectedAction -= to!int(buyLength);
            if (state.selectedAction < 0) {
               state.selectedAction = 0;
            }
         }
         else {
            state.selectedAction += to!int(buyLength);
            if (state.selectedAction > buyLength - 1) {
                  state.selectedAction = to!int(buyLength);
            }
         }
      }
   };

   static ulong getCap(State* state)
   {
      ulong cap = 0;
      if (state.menu == Menus.move)
      {
         cap = state.location.locations.length;
      }
      else if (state.menu == Menus.actions)
      {
         cap = state.location.actions.length;
      }
      else if (state.menu == Menus.combat)
      {
         cap = state.player.combatActions.length;
      }
      else if (state.menu == Menus.attack)
      {
         cap = state.player.gear.weapon.attacks.length;
      }
      else if (state.menu == Menus.shop)
      {
         if (state.selectedAction < state.location.shop.items.length) {

         cap = state.location.shop.items.length;
         } else {
            cap = state.player.inventory.length + state.location.shop.items.length;
         }
      }
      return cap;
   }

   static void execute(State* state)
   {

      if (state.menu == Menus.move)
      {
         state.location = locations.instantiateLocation(
               state.location.locations[state.selectedAction].className);
         state.menu = Menus.actions;
      }
      else if (state.menu == Menus.combat)
      {
         state.player.combatActions[state.selectedAction].onExecute(state);
      }
      else if (state.menu == Menus.attack)
      {
         short damageToEnemy = Combat.attack(state.enemy, state.player, state.selectedAction);
         state.enemy.health -= damageToEnemy;
         if (state.enemy.health <= 0)
         {
            Combat.setRewards(state);
            state.menu = Menus.combatOver;
         }

         short damageToPlayer = Combat.enemyAction(state.enemy, state.player);
         state.player.health -= damageToPlayer;
         if (state.player.health <= 0)
         {
            state.menu = Menus.playerKilled;
            state.player.renew();
         }
      }
      else if (state.menu == Menus.playerKilled)
      {
         state.menu = Menus.actions;
      }
      else if (state.menu == Menus.combatOver)
      {
         state.menu = Menus.actions;
      } else if (state.menu == Menus.shop) {
         Shop.buyOrSell(state);
      }
      else
      {
         state.location.actions[state.selectedAction].onExecute(state);
      }
   }
}
