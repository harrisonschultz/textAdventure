module actions.randomCombat;
import actions.action;
import std.stdio;
import std.random;
import std.conv;
import std.math;

class RandomCombat : Action
{

    this()
    {
        name = "Fight";
    }

    override void onExecute(State* state)
    {
        ulong length = state.location.enemies.length;
        state.selectedAction = 0;
        state.menu = Menus.combat;
        if (length == 1)
        {
            state.location.enemies[0].renew();
            state.enemy = state.location.enemies[0];
        }
        else
        {
            ulong enemyIndex = uniform(0, state.location.enemies.length - 1);
            state.location.enemies[enemyIndex].renew();
            state.enemy = state.location.enemies[enemyIndex];
        }
    }
}
