module actions.next;

import actions.action;
import types.menus;

class Next : Action {

    this() {
        name = "Continue";
    }
    
    override void onExecute (State* state) {
        state.menu = Menus.actions;
    }

}