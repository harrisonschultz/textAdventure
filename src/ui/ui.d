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
import characters.player;
import types.menus;
import types.listItem;

class UI
{

    this(int width, int height, sfRenderWindow* win)
    {
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
    sfRectangleShape* descriptionBox;
    sfRectangleShape* optionsBox;
    sfRectangleShape* detailsBox;
    sfRectangleShape* highlight;

    void update(State state)
    {
        createDescriptionBox();
        createOptionsBox();
        createDetailsBox();
        createSelectionHighlight(state.selectedAction);
        fillDetails(state.player);
        if (state.menu == Menus.actions)
        {
            string[] actions;
            foreach (act; state.location.actions)
            {
                actions ~= act.name;
            }
            createActionList(actions);
            createText(state.location.description, descriptionBox);
        }
        else if (state.menu == Menus.move)
        {
            string[] actions;
            foreach (act; state.location.locations)
            {
                actions ~= act.name;
            }
            createActionList(actions);
            createText(state.location.description, descriptionBox);
        }
        else if (state.menu == Menus.combat)
        {
            string[] actions;
            foreach (act; state.player.combatActions)
            {
                actions ~= act.name;
            }
            createActionList(actions);
            createText(state.location.description, descriptionBox);
        }
        else if (state.menu == Menus.attack)
        {
            string[] actions;
            foreach (act; state.player.gear.weapon.attacks)
            {
                actions ~= act.name;
            }
            createActionList(actions);
            createText(state.location.description, descriptionBox);
        }
    }

    void createActionList(string[] items)
    {
        short characterSize = 25;
        const(short) paddingBetweenLines = 10;
        short index = 0;
        auto font = sfFont_createFromFile("./assets/SourceSansPro-Regular.ttf");

        foreach (item; items)
        {
            // Find were to put new line characters (text wrap) 
            // rectSize.x - 20 (-20 is for the 'padding' on each side.)
            const(sfVector2f) rectSize = sfRectangleShape_getSize(optionsBox);
            const(short) totalColumns = cast(short)(rectSize.x - 20) / 10;
            string wrappedWords = wrap(item, totalColumns);

            sfText* text = sfText_create();
            sfText_setString(text, toStringz(wrappedWords));
            sfText_setCharacterSize(text, characterSize);
            sfText_setColor(text, sfWhite);
            sfText_setFont(text, font);

            // Get Box position and add the text to it
            sfVector2f pos = sfRectangleShape_getPosition(optionsBox);
            sfText_setPosition(text, sfVector2f(pos.x + 15,
                    pos.y + 5 + ((characterSize + paddingBetweenLines) * index)));

            // Draw
            sfRenderWindow_drawText(window, text, null);
            index++;
        }
    }

    void createSelectionHighlight(int actionIndex)
    {
        const(float) padding = 5;
        const(float) lineHeight = 25; // Configure
        const(short) paddingBetweenLines = 10;
        sfRectangleShape_setFillColor(highlight, sfColor(100, 107, 115, 60));
        sfRectangleShape_setPosition(highlight, sfVector2f(padding + 20,
                windowHeight - 300 + 20 + ((lineHeight + paddingBetweenLines) * actionIndex)
                + padding));
        sfRectangleShape_setSize(highlight, sfVector2f(100, lineHeight + 10));

        // Draw
        sfRenderWindow_drawRectangleShape(window, highlight, null);
    }

    void createDescriptionBox()
    {
        const(float) padding = 20;
        const(float) width = to!float(windowWidth - 300 - padding);
        const(float) height = to!float(windowHeight - 300 - padding); // Configure
        sfRectangleShape_setFillColor(descriptionBox, sfColor(67, 70, 75, 200));
        sfRectangleShape_setPosition(descriptionBox, sfVector2f(padding, padding));
        sfRectangleShape_setSize(descriptionBox, sfVector2f(width, height));

        // Draw
        sfRenderWindow_drawRectangleShape(window, descriptionBox, null);
    }

    void createOptionsBox()
    {
        const(float) padding = 20;
        const(float) width = to!float(windowWidth - 300 - padding);
        const(float) height = to!float(300 - padding - padding);
        const(float) posX = padding;
        const(float) posY = to!float(windowHeight - height - padding);

        // Configure
        sfRectangleShape_setFillColor(optionsBox, sfColor(67, 70, 75, 200));
        sfRectangleShape_setPosition(optionsBox, sfVector2f(posX, posY));
        sfRectangleShape_setSize(optionsBox, sfVector2f(width, height));

        // Draw
        sfRenderWindow_drawRectangleShape(window, optionsBox, null);
    }

    void createDetailsBox()
    {
        const(float) padding = 20;
        const(float) width = 300 - padding - padding;
        const(float) height = to!float(windowHeight - padding - padding);
        const(float) posX = to!float(windowWidth - width - padding);
        const(float) posY = padding; // Configure
        sfRectangleShape_setFillColor(detailsBox, sfColor(67, 70, 75, 200));
        sfRectangleShape_setPosition(detailsBox, sfVector2f(posX, posY));
        sfRectangleShape_setSize(detailsBox, sfVector2f(width, height));

        // Draw
        sfRenderWindow_drawRectangleShape(window, detailsBox, null);
    }

    void createText(string words, sfRectangleShape* rect, float offsetX = 0,
            float offsetY = 0, short characterSize = 25, bool wrapText = true)
    {
        auto font = sfFont_createFromFile("./assets/SourceSansPro-Regular.ttf"); // Find were to put new line characters (text wrap) 
        // rectSize.x - 20 (-20 is for the 'padding' on each side.)
        const(sfVector2f) rectSize = sfRectangleShape_getSize(rect);
        const(short) totalColumns = cast(short)(rectSize.x - 20) / 10;
        string wrappedWords = words;
        if (wrapText)
        {
            wrappedWords = wrap(words, totalColumns); //auto text_color = sfColor(255, 255, 255, 255);
        }
        sfText* text = sfText_create();
        sfText_setString(text, toStringz(wrappedWords));
        sfText_setCharacterSize(text, characterSize);
        sfText_setColor(text, sfWhite);
        sfText_setFont(text, font); // Get Box position and add the text to it
        sfVector2f pos = sfRectangleShape_getPosition(rect);
        sfText_setPosition(text, sfVector2f(pos.x + 10 + offsetX, pos.y + 10 + offsetY)); // Draw
        sfRenderWindow_drawText(window, text, null);
    }

    void fillDetails(Player player)
    {
        const(string) attrColumnOne = "STR:\nDEX:\nPER:";
        const(string) attrColumnTwo = format("%s\n%s\n%s", player.attr["str"],
                player.attr["dex"], player.attr["per"]);
        const(string) attrColumnThree = "INT:\nCON:\n";
        const(string) attrColumnFour = format("%s\n%s", player.attr["mnd"], player.attr["con"]);

        createText(attrColumnOne, detailsBox, 0, 150, 20, false);
        createText(attrColumnTwo, detailsBox, 60, 150, 20, false);
        createText(attrColumnThree, detailsBox, 120, 150, 20, false);
        createText(attrColumnFour, detailsBox, 180, 150, 20, false);
    }

}
