module locations.haydensBorough;

import locations.location;
import actions.move;
import actions.randomCombat;
import actions.shopping;
import locations.ratsNest;
import characters.rat;
import shops.haydensBoroughShop;
import state.state;

class HaydensBorough : Location
{

   this()
   {
      name = "Hayden's Borough";
      description = "A small village, at a crossroads. A stopping point for traders and travellers alike. A few local craftsman have stalls in the market. There is likely a few small jobs that could be picked up from the tavern.";
      actions = [new Move(), new Shopping()];
      shop = new HaydensBoroughShop();
      locations = [plainsLoc];
      enemies = [];
   }

}
