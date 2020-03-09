module locations.location;
import actions.action;
import characters.enemy;

class Location {
    string description;
    
    Action[] actions;
    Enemy[] enemies;
    Location[] connections;
}