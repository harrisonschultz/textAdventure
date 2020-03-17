module actions.move;
import actions.action;
import std.stdio;
import types.menus;

class Move : Action {

    this() {
        name = "Move";
    }
    
    override void onExecute (State* state) {
        state.selectedAction = 0;
        state.menu = Menus.move;
    }

}