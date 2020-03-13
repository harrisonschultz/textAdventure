module state.state;
import characters.player;
import characters.character;
import locations;
import std.conv;
import types.menus;
import std.stdio;
import combat.combat;

class State
{

    this()
    {
        player = new Player();
        location = new Plains();
        menu = Menus.actions;
        selectedAction = 0;
    }

    Player player;
    Location location;
    Character enemy;
    Menus menu;
    int selectedAction;

    
}
