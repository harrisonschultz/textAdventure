module actions.move;
import actions.action;
import std.stdio;

class Move : Action {

    this() {
        name = "Move";
    }
    
    State onExecute (State state) {
        writeln("move");
        return state;
    }

}