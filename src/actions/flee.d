module actions.escape;

import actions.action;
import std.stdio;
import types.menus;

class Flee : Action {

    this() {
        name = "Flee";
    }
    
    override State onExecute (State state) {
        state.menu = Menus.actions;
        return state;
    }

}