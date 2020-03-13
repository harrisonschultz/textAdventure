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
      state.menu = Menus.actions;
   }

}
