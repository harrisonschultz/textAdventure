module shops.shop;

import std.conv;
public import items.item;
import state.state;
import std.algorithm.mutation : remove;

class Shop {
   Item[] items;

   static buyOrSell(State* state) {
      int itemIndex = state.selectedAction;
      // Sell
       if (state.selectedAction >= state.location.shop.items.length) {
          itemIndex -= state.location.shop.items.length;
            sell(state, itemIndex);
       } else {
          buy(state, itemIndex);
       }
   }

   static buy(State* state, int index) {
      if (state.player.gold >= state.location.shop.items[index].value) {
         state.selectedAction = 0;
      state.player.gold -= state.location.shop.items[index].value;
      state.player.inventory ~= state.location.shop.items[index];
      }
   }

   static sell(State* state, int index) {
      // Set the selected action back to the top of the sell box
      if (state.player.inventory.length == 1) {
         state.selectedAction = 0;
      } else {
         state.selectedAction = to!int(state.location.shop.items.length);
      }
      state.player.gold += state.player.inventory[index].value;
      state.player.inventory = state.player.inventory.remove(index);
   }
}