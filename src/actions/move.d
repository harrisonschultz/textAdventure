module actions.move;
import actions.action;
import std.stdio;
import types.menus;

class Move : Action {

    this() {
        name = "Move";
    }
    
    override void onExecute (State* state) {
        state.menu = Menus.move;
    }

}