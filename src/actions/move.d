module actions.move;
import actions.action;
import std.stdio;
import types.menus;

class Move : Action {

    this() {
        name = "Move";
    }
    
    override State onExecute (State state) {
        state.menu = Menus.move;
        return state;
    }

}