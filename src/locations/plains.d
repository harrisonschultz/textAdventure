module locations.plains;
import locations.location;
import actions.move;
import actions.randomCombat;
import locations.ratsNest;
import characters.rat;
import state.state;


class Plains : Location
{

    this()
    {
        name = "Plains";
        description = "Grass as far as the eye can see. Fields of amber grain litter the grassland.";
        actions = [new Move(), new RandomCombat()];
        locations = [ratsNestLoc];
        enemies = [new Rat()];
    }

    override State onExecute(State state)
    {
        state.location = this;
        return state;
    }
}
