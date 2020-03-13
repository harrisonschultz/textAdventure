module items.loot;

import items.item;

class Loot {
   double dropChance;

   Item item;

   this (Item i, double chance ) {
      item = i;
      dropChance = chance;
   }
}