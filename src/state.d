module state.state;
import characters.player;
import characters.enemy;
import locations.location;
import locations.plains;
import std.conv;

class State {

    this() {
        player = new Player();
        inCombat = false;
        location = new Plains();
        selectedAction = 0;
    }

    Player player;
    bool inCombat;
    Location location;
    Enemy enemy;
    int selectedAction;

    void moveSelectionDown() {
        selectedAction++;
        if (selectedAction + 1 > location.actions.length) {
            selectedAction = 0;
        }
    };

    void moveSelectionUp() {
        selectedAction--;
        if (selectedAction < 0) {
            selectedAction = to!int(location.actions.length) - 1;
        }
    };
}