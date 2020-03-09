module actions.action;
public import state.state;

class Action {
    string name;
    State onExecute;
}