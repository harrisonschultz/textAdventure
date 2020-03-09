import derelict.sfml2.system;
import derelict.sfml2.window;
import derelict.sfml2.audio;
import derelict.sfml2.graphics;
import derelict.sfml2.network;
import std.stdio;
import std.string;
import std.random;
import std.algorithm;
import ui.ui;
import state.state;

int window_width = 1200;
int window_height = 900;
string window_title = "Text Adventure";

void main() {
    DerelictSFML2System.load();
    DerelictSFML2Window.load();
    DerelictSFML2Audio.load();
    DerelictSFML2Graphics.load();
    DerelictSFML2Network.load();

    // create the clock
    sfClock *clock = sfClock_create();

    // create game window
    sfVideoMode mode = {window_width, window_height, 32};
    sfRenderWindow *win = sfRenderWindow_create(mode, toStringz(window_title),
                                                sfResize | sfClose, null);

    // create and set the window's view
    sfView *view = sfView_create();
    sfView_setSize(view, sfVector2f(window_width, window_height));
    sfView_setViewport(view, sfFloatRect(0, 0, 1, 1));

    // set the framerate limit
    sfRenderWindow_setFramerateLimit(win, 60);

    // create the ui
    UI ui = new UI(window_width , window_height, win);
  

    // Init state
    State state = new State();

    // main loop
    while(sfRenderWindow_isOpen(win)) {
        // get current elapsed time
        int elapsed = sfTime_asMilliseconds(sfClock_getElapsedTime(clock));
        // poll events
        auto event = new sfEvent;
             sfRenderWindow_clear(win, sfBlack);
        ui.update(state);
        while(sfRenderWindow_pollEvent(win, event)) {
            if (event.type == sfEvtClosed) {
                sfRenderWindow_close(win);
            } else if(event.type == sfEvtMouseButtonPressed) {

            } else if (event.type == sfEvtKeyPressed) {
                if (event.key.code == 22) {
                    state.moveSelectionDown();
                    ui.createText("w key press", ui.detailsBox);
                }
            }
        }
        // clear the window
   
        // sfRenderWindow_setView(win, view);

        // sfView_reset(view, sfFloatRect(0, 0, 800, 600));
        
        
        // display everything
        sfRenderWindow_display(win);
    }
}