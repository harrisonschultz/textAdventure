module actions.next;

import actions.action;
import types.menus;

class Next : Action {

    this() {
        name = "Continue";
    }
    
    override void onExecute (State* state) {
        state.selectedAction = 0;
        state.menu = Menus.actions;
    }

}