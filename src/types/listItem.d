module types.listItem;

import state.state;

class ListItem
{
   string name;
   abstract void onExecute(State*);
}
