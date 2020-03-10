module locations.location;

import types.listItem;
public import actions.action;
public import characters.enemy;
public import locations.locId;

class Location : ListItem
{
    string description;

    Action[] actions;
    Enemy[] enemies;
    LocId[] locations;

}
