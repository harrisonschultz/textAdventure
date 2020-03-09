module ui.ui;
import derelict.sfml2.system;
import derelict.sfml2.window;
import derelict.sfml2.audio;
import derelict.sfml2.graphics;
import derelict.sfml2.network;
import std.string;
import std.ascii;
import std.conv;
import state.state;
import actions.action;


class UI {

    this(int width, int height, sfRenderWindow* win) {
        windowWidth = width;
        windowHeight = height;
        window = win;

        descriptionBox = sfRectangleShape_create();
        optionsBox = sfRectangleShape_create();
        detailsBox = sfRectangleShape_create();
        highlight = sfRectangleShape_create();
        this.createDescriptionBox();
    }

    public:
        int windowWidth;
        int windowHeight;
        sfRenderWindow* window;
        sfRectangleShape *descriptionBox;
        sfRectangleShape *optionsBox;
        sfRectangleShape *detailsBox;
        sfRectangleShape *highlight;

        void update(State state) {
            createDescriptionBox();
            createOptionsBox();
            createDetailsBox();
            createSelectionHighlight(state.selectedAction);
            createActionList(state.location.actions);
            if (!state.inCombat) {
                createText(state.location.description, descriptionBox);
            }
        }

        void createActionList(Action[] actions) {
            foreach (act; actions)
            {
                createText(act.name, optionsBox);
            }

        }

        void createSelectionHighlight(int actionIndex) {
            const(float) padding = 10;
            const(float) lineHeight = 25;
            // Configure
            sfRectangleShape_setFillColor(highlight, sfColor(100, 107, 115, 60));
            sfRectangleShape_setPosition(highlight, sfVector2f(padding + 20, windowHeight - 300 + 20 + (lineHeight * actionIndex) + padding));
            sfRectangleShape_setSize(highlight, sfVector2f(100, lineHeight + 10));

            // Draw
            sfRenderWindow_drawRectangleShape(window, highlight, null);
        }

        void createDescriptionBox() {
            const(float) padding = 20;
            const(float) width = to!float(windowWidth - 300 - padding );
            const(float) height = to!float(windowHeight - 300 - padding);

            // Configure
            sfRectangleShape_setFillColor(descriptionBox, sfColor(67, 70, 75, 200));
            sfRectangleShape_setPosition(descriptionBox, sfVector2f(padding, padding));
            sfRectangleShape_setSize(descriptionBox, sfVector2f(width, height));

            // Draw
            sfRenderWindow_drawRectangleShape(window, descriptionBox, null);
        }

        void createOptionsBox() {
            const(float) padding = 20;
            const(float) width = to!float(windowWidth - 300 - padding );
            const(float) height = to!float(300 - padding - padding );
            const(float) posX = padding;
            const(float) posY = to!float(windowHeight - height - padding);

            // Configure
            sfRectangleShape_setFillColor(optionsBox, sfColor(67, 70, 75, 200));
            sfRectangleShape_setPosition(optionsBox, sfVector2f(posX, posY));
            sfRectangleShape_setSize(optionsBox, sfVector2f(width, height));

            // Draw
            sfRenderWindow_drawRectangleShape(window, optionsBox, null);
        }

        void createDetailsBox() {
            const(float) padding = 20;
            const(float) width = 300 - padding - padding;
            const(float) height = to!float(windowHeight - padding - padding );
            const(float) posX = to!float(windowWidth - width - padding);
            const(float) posY = padding;

            // Configure
            sfRectangleShape_setFillColor(detailsBox, sfColor(67, 70, 75, 200));
            sfRectangleShape_setPosition(detailsBox, sfVector2f(posX,  posY));
            sfRectangleShape_setSize(detailsBox, sfVector2f(width, height));

            // Draw
            sfRenderWindow_drawRectangleShape(window, detailsBox, null);
        }

    void createText(string words, sfRectangleShape* rect) {
        short characterSize = 25;
        
        auto font = sfFont_createFromFile("./assets/SourceSansPro-Regular.ttf"); 

        // Find were to put new line characters (text wrap) 
        // rectSize.x - 20 (-20 is for the 'padding' on each side.)
        const(sfVector2f) rectSize = sfRectangleShape_getSize(rect);
        const(short) totalColumns = cast(short) (rectSize.x - 20) / 10;
        string wrappedWords = wrap(words, totalColumns);

        //auto text_color = sfColor(255, 255, 255, 255);
        sfText* text = sfText_create();
        sfText_setString(text, toStringz(wrappedWords));
        sfText_setCharacterSize(text, characterSize);
        sfText_setColor(text, sfWhite);
        sfText_setFont(text, font);

        // Get Box position and add the text to it
        sfVector2f pos = sfRectangleShape_getPosition(rect);
        sfText_setPosition(text, sfVector2f(pos.x + 10, pos.y + 10));

           // Draw
        sfRenderWindow_drawText(window, text, null);
    }

    
}