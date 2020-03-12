module characters.character;
public import details.attributes;
public import details.gear;
public import details.stats;

class Character
{
    short[string] attr;
    Gear gear;
    string description;
    short health;
    short expReward;
    short level;
    short exp;
    void renew()
    {
        this.health = Stats.getMaxHealth(this);
    }
}
