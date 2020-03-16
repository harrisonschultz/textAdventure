module locations.location;

import types.listItem;
import characters.character;
import shops.shop;
public import actions.action;
public import locations.locId;
import std.stdio;

class Location : ListItem
{
    string description;

    Action[] actions;
    Character[] enemies;
    LocId[] locations;
    Shop shop;

    override void onExecute(State* state)
    {
        state.location = this;
    }
}
