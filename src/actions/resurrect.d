module actions.resurrect;

import actions.action;
import types.menus;

class Resurrect : Action
{

   this()
   {
      name = "Continue";
   }

   override void onExecute(State* state)
   {
      state.selectedAction = 0;
      state.menu = Menus.actions;
   }

}
