module locations.ratsNest;

import locations.location;
import actions.move;
import actions.randomCombat;
import locations.plains;
import characters.rat;
import state.state;

class RatsNest : Location
{

   this()
   {
      name = "Rat's Nest";
      description = "A dark hole in the ground blanketed by leaves and dirt. Its completely infested with rats.";
      actions = [new Move(), new RandomCombat()];
      locations = [plainsLoc];
      enemies = [new Rat()];
   }

   override State onExecute(State state)
   {
      state.location = this;
      return state;
   }
}
