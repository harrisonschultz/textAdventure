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

    void moveSelectionDown()
    {
        ulong cap = getCap();
        selectedAction++;

        if (selectedAction + 1 > cap)
        {
            selectedAction = 0;
        }
    };

    void moveSelectionUp()
    {
        ulong cap = getCap();
        selectedAction--;

        if (selectedAction < 0)
        {
            selectedAction = to!int(cap) - 1;
        }
    };

    ulong getCap()
    {
        ulong cap = 0;
        if (menu == Menus.move)
        {
            cap = location.locations.length;
        }
        else if (menu == Menus.actions)
        {
            cap = location.actions.length;
        }
        else if (menu == Menus.combat)
        {
            cap = player.combatActions.length;
        }
        else if (menu == Menus.attack)
        {
            cap = player.gear.weapon.attacks.length;
        }
        return cap;
    }

    State execute()
    {
        if (menu == Menus.move)
        {
            location = locations.instantiateLocation(location.locations[selectedAction].className);
            menu = Menus.actions;
            return this;
        }
        else if (menu == Menus.combat)
        {
            return player.combatActions[selectedAction].onExecute(this);
        }
        else if (menu == Menus.attack)
        {
            short damageToEnemy = Combat.attack(enemy, player, selectedAction);
            enemy.health -= damageToEnemy;
            if (enemy.health <= 0)
            {
                menu = Menus.combatOver;
            }
            return this;
        }
        return location.actions[selectedAction].onExecute(this);
    }

}
