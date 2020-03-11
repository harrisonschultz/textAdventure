module locations.location;

import types.listItem;
import characters.character;
public import actions.action;
public import locations.locId;

class Location : ListItem
{
    string description;

    Action[] actions;
    Character[] enemies;
    LocId[] locations;

}
