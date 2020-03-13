module actions.attack;

import actions.action;
import std.stdio;
import types.menus;

class Attack : Action {

    this() {
        name = "Attack";
    }
    
    override void onExecute (State* state) {
        state.menu = Menus.attack;
    }

}