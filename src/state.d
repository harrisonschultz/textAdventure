module state.state;
import characters.player;
import characters.enemy;
import locations;
import std.conv;
import types.menus;
import std.stdio;

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
    Enemy enemy;
    Menus menu;
    int selectedAction;

    void moveSelectionDown()
    {
        ulong cap;
        selectedAction++;
        if (menu == Menus.move)
        {
            cap = location.locations.length;
        }
        else if (menu == Menus.actions)
        {
            cap = location.actions.length;
        }
        if (selectedAction + 1 > cap)
        {
            selectedAction = 0;
        }
    };

    void moveSelectionUp()
    {
        ulong cap;
        selectedAction--;
        if (menu == Menus.move)
        {
            cap = location.locations.length;
        }
        else if (menu == Menus.actions)
        {
            cap = location.actions.length;
        }
        if (selectedAction < 0)
        {
            selectedAction = to!int(cap) - 1;
        }
    };

    State execute()
    {
        if (menu == Menus.move)
        {
            writeln(location.locations[selectedAction].name);
            location = locations.instantiateLocation(location.locations[selectedAction].className);
            writeln(location);
            menu = Menus.actions;
            return this;
        }
        return location.actions[selectedAction].onExecute(this);
    }

}
