module locations.plains;
import locations.location;
import actions.move;

class Plains : Location {
    
    this() {
        description = "Grass as far as the eye can see. Fields of amber grain litter the grassland.";
        actions = [new Move()];
        // locations 
        // enemies
    }
}