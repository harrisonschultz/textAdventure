module locations.location;

import types.listItem;
import characters.character;
public import actions.action;
public import locations.locId;
import std.stdio;

class Location : ListItem
{
    string description;

    Action[] actions;
    Character[] enemies;
    LocId[] locations;

    override void onExecute(State* state)
    {
        state.location = this;
    }
}
