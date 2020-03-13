module characters.character;
public import details.attributes;
public import details.gear;
public import details.stats;
public import items.loot;

class Character
{
    short[string] attr;
    Gear gear;
    string description;
    short health;
    short expReward;
    short level;
    short exp;
    Loot[] loot;
    void renew()
    {
        this.health = Stats.getMaxHealth(this);
    }
}
