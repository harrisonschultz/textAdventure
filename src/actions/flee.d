module actions.escape;

import actions.action;
import std.stdio;
import types.menus;

class Flee : Action {

    this() {
        name = "Flee";
    }
    
    override void onExecute (State* state) {
        state.selectedAction = 0;
        state.menu = Menus.actions;
    }

}