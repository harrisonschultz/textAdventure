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
import shops.shop;
import types.menus;
import std.stdio;
import details.stats;
import characters.character;
import types.listItem;
import actions.next;
import items.item;
import combat.combat;
import actions.resurrect;

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

        font = sfFont_createFromFile("./assets/SourceSansPro-Regular.ttf");
    }

public:
    int windowWidth;
    int windowHeight;
    sfRenderWindow* window;
    sfRectangleShape* descriptionBox;
    sfRectangleShape* optionsBox;
    sfRectangleShape* detailsBox;
    sfRectangleShape* highlight;
    sfFont* font;

    void update(State* state)
    {
        createDescriptionBox();
        createOptionsBox();
        createDetailsBox();

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
            createText(state.enemy.description, descriptionBox);

            healthDisplay(state.enemy, descriptionBox, 0, 200, 20, false);
        }
        else if (state.menu == Menus.attack)
        {
            string[] actions;
            foreach (act; state.player.gear.weapon.attacks)
            {
                actions ~= act.name;
            }
            createActionList(actions);
            createText(state.enemy.description, descriptionBox);

            healthDisplay(state.enemy, descriptionBox, 0, 200, 20, false);
        }
        else if (state.menu == Menus.combatOver)
        {
            createActionList([new Next().name]);
            createText(Combat.combatRewardText(state), descriptionBox);
        }
        else if (state.menu == Menus.playerKilled)
        {
            createActionList([new Resurrect().name]);
            createText(Combat.deathText(state), descriptionBox);
        }
        else if (state.menu == Menus.shop)
        {
            createActionList([new Resurrect().name]);
            createShopList(state.location.shop, state.player.inventory);
        }

        createSelectionHighlight(state);
    }

    void createActionList(string[] items)
    {
        short characterSize = 25;
        const(short) paddingBetweenLines = 10;
        short index = 0;

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

    void createSelectionHighlight(State* state)
    {
        const(float) padding = 5;
        const(float) lineHeight = 25; // Configure
        const(short) paddingBetweenLines = 10;
        sfRectangleShape_setFillColor(highlight, sfColor(200, 107, 115, 60));

        if (state.menu == Menus.shop)
        {
            ulong buyLength = state.location.shop.items.length - 1;
            ulong sellLength = state.player.inventory.length - 1;
            sfRectangleShape_setSize(highlight, sfVector2f(300, lineHeight + 10));
            // Render buy selected highlight
            if (state.selectedAction < sellLength)
            {
                sfRectangleShape_setPosition(highlight, sfVector2f(padding + 20,
                        windowHeight + 20 + (
                        (lineHeight + paddingBetweenLines) * state.selectedAction) + padding));
            }
            else
            {
                sfRectangleShape_setPosition(highlight, sfVector2f(padding + 20,
                        windowHeight + 20 + ((lineHeight + paddingBetweenLines) * (
                        state.selectedAction - buyLength)) + padding));
            }

        }
        else
        {
            sfRectangleShape_setSize(highlight, sfVector2f(350, lineHeight + 10));
            sfRectangleShape_setPosition(highlight, sfVector2f(padding + 20,
                    windowHeight - 300 + 20 + (
                    (lineHeight + paddingBetweenLines) * state.selectedAction) + padding));
        }
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
        // Health & Status
        healthDisplay(cast(Character) player, detailsBox, 0, 140, 18);

        // Exp & level
        createText("Level", detailsBox, 0, 180, 18, false);
        createText(to!string(player.level), detailsBox, 180, 180, 18, false);
        createText("Experience", detailsBox, 0, 205, 18, false);
        createText(format("%s / %s", to!string(player.exp),
                to!string(Stats.getMaxExp(player))), detailsBox, 180, 205, 18, false); // Unallocated Points
        createText("Attribute Points", detailsBox, 0, 235, 18, false);
        createText(to!string(player.openAttrPoints), detailsBox, 180, 235, 18, false);
        createText("Skill Points", detailsBox, 0, 260, 18, false);
        createText(to!string(player.openSkillPoints), detailsBox, 180, 260, 18, false); // Attributes
        const(string) attrColumnOne = "STR\nDEX\nPER";
        const(string) attrColumnTwo = format("%s\n%s\n%s", player.attr["str"],
                player.attr["dex"], player.attr["per"]);
        const(string) attrColumnThree = "INT\nCON\n";
        const(string) attrColumnFour = format("%s\n%s", player.attr["mnd"], player.attr["con"]);
        createText(attrColumnOne, detailsBox, 0, 290, 18, false);
        createText(attrColumnTwo, detailsBox, 60, 290, 18, false);
        createText(attrColumnThree, detailsBox, 120, 290, 18, false);
        createText(attrColumnFour, detailsBox, 180, 290, 18, false); // Golds
        createText("Gold", detailsBox, 0, 375, 18, false);
        createText(to!string(player.gold), detailsBox, 180, 375, 18, false); // Inventory
        createText("Inventory", detailsBox, 70, 405, 18, false);
        inventoryDisplay(player, detailsBox, 0, 430, 18, true);
    }

    void healthDisplay(Character character, sfRectangleShape* rect, float offsetX = 0,
            float offsetY = 0, short characterSize = 25, bool wrapText = true)
    {
        // Health & Status
        createText("Health", rect, offsetX, offsetY, characterSize, false);
        createText(to!string(character.health), rect, offsetX + 80, offsetY, characterSize, false);
        createText(format("/ %s", to!string(Stats.getMaxHealth(character))),
                rect, offsetX + 100, offsetY, characterSize, wrapText);
    }

    void inventoryDisplay(Player player, sfRectangleShape* rect, float offsetX = 0,
            float offsetY = 0, short characterSize = 25, bool wrapText = true)
    {
        // Get names of all inventory items.
        string[] itemNames;
        foreach (Item item; player.inventory)
        {
            itemNames ~= item.name;
        }

        // Sort names.
        foreach (i, name; itemNames)
        {
            createText(name, rect, offsetX, offsetY + (characterSize * i + 5),
                    characterSize, wrapText);
        }

    }

    void createShopList(Shop shop, Item[] inv)
    {
        float offsetX = 20;
        float offsetY = 20;
        short characterSize = 25;

        // Buy
        createText("Buy", descriptionBox, offsetX, offsetY);
        createText("Price", descriptionBox, offsetX + 215, offsetY);

        foreach (i, item; shop.items)
        {
            createText(item.name, descriptionBox, offsetX,
                    offsetY + (25 * i + 5) + 50, characterSize, false);
            createText(to!string(item.value), descriptionBox, offsetX + 240,
                    offsetY + (25 * i + 5) + 50, characterSize, false);
        }

        // Sell
        createText("Sell", descriptionBox, offsetX + 320, 20);
        createText("Value", descriptionBox, offsetX + 320 + 215, 20);

        foreach (p, it; inv)
        {
            createText(it.name, descriptionBox, offsetX + 320,
                    offsetY + (25 * p + 5) + 50, characterSize, false);
            createText(to!string(it.value), descriptionBox, offsetX + 320 + 240,
                    offsetY + (25 * p + 5) + 50, characterSize, false);
        }
    }

}
