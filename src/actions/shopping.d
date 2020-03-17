module actions.shopping;

import actions.action;
import std.stdio;
import types.menus;

class Shopping : Action {

    this() {
        name = "Shop";
    }
    
    override void onExecute (State* state) {
        state.selectedAction = 0;
        state.menu = Menus.shop;
    }

}