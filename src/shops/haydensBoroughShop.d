module shops.haydensBoroughShop;

import shops.shop;
import items.weapons.rustedSword;

class HaydensBoroughShop : Shop {
   
   this() {
      items = [new RustedSword(), new RustedSword(), new RustedSword()];
   }
}