module actions.randomCombat;
import actions.action;
import std.stdio;

class RandomCombat : Action {

    this() {
        name = "Fight";
    }
    
    override State onExecute (State state) {
        writeln("Fight");
        return state;
    }
}