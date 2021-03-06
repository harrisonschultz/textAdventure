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
      createSelectionHighlight(state);

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
      else if (state.menu == Menus.character)
      {
         createCharacterSheet(&state.player);
      }
      createText(to!string(state.selectedAction), optionsBox, 400);
      createText(to!string(state.menu), optionsBox, 400, 30);
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
         ulong buyLength = state.location.shop.items.length;
         ulong sellLength = state.player.inventory.length;
         sfRectangleShape_setSize(highlight, sfVector2f(300, lineHeight + 10));
         // Render buy selected highlight
         if (state.selectedAction >= buyLength)
         {
            sfRectangleShape_setPosition(highlight, sfVector2f(padding + 30 + 320,
                  +((lineHeight + paddingBetweenLines) * (state.selectedAction - buyLength)) + 100));
         }
         else
         {

            sfRectangleShape_setPosition(highlight, sfVector2f(padding + 30,
                  +((lineHeight + paddingBetweenLines) * state.selectedAction) + 100));
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

   sfRectangleShape* createBox(sfRectangleShape* parent, float width,
         float height, float posX, float posY)
   {
      sfRectangleShape* box = sfRectangleShape_create();
      sfVector2f origin = sfRectangleShape_getPosition(parent);

      sfRectangleShape_setFillColor(box, sfColor(47, 75, 72, 255));
      sfRectangleShape_setPosition(box, sfVector2f(origin.x + posX, origin.y + posY));
      sfRectangleShape_setSize(box, sfVector2f(width, height));

      // Draw
      sfRenderWindow_drawRectangleShape(window, box, null);
      return box;
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

   void healthDisplay(Character character, sfRectangleShape* rect,
         float offsetX = 0, float offsetY = 0, short characterSize = 25, bool wrapText = true)
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
         createText(name, rect, offsetX, offsetY + (characterSize * i + 5), characterSize, wrapText);
      }

   }

   void createShopList(Shop shop, Item[] inv)
   {
      float offsetX = 20;
      float offsetY = 20;
      short characterSize = 25;
      float linePadding = 10;

      // Buy
      createText("Buy", descriptionBox, offsetX, offsetY);
      createText("Price", descriptionBox, offsetX + 215, offsetY);

      foreach (i, item; shop.items)
      {
         createText(item.name, descriptionBox, offsetX,
               offsetY + (25 + linePadding) * i + 50, characterSize, false);
         createText(to!string(item.value), descriptionBox, offsetX + 240,
               offsetY + (25 + linePadding) * i + 50, characterSize, false);
      }

      // Sell
      createText("Sell", descriptionBox, offsetX + 320, 20);
      createText("Value", descriptionBox, offsetX + 320 + 215, 20);

      foreach (p, it; inv)
      {
         createText(it.name, descriptionBox, offsetX + 320,
               offsetY + (25 + linePadding) * p + 50, characterSize, false);
         createText(to!string(it.value), descriptionBox, offsetX + 320 + 240,
               offsetY + (25 + linePadding) * p + 50, characterSize, false);
      }
   }

   void gearDisplay(Player* player, sfRectangleShape* rect, float offsetX = 0,
         float offsetY = 0, short characterSize = 25, bool wrapText = true) {

         short labelSize = 20;
         short nameSize = 20;

         string weaponName = player.gear.weapon.name;
         // string headName = player.gear.head.name;
         // string chestName = player.gear.chest.name;
         // string pantsName = player.gear.pants.name;
         // string ringName = player.gear.ring.name;
         // string necklaceName = player.gear.necklace.name;

         string headName = "sadfj";
         string chestName = "sadfj";
         string pantsName = "sadfj";
         string ringName = "sadfj";
         string necklaceName = "sadfj";

         createText("Weapon", rect, 0, 0, labelSize);
         createText(weaponName, rect, 120, 0, nameSize);
         createText("Head", rect, 0, 30, labelSize);
         createText(headName, rect, 120, 30, nameSize);
         createText("Chest", rect, 0, 60, labelSize);
         createText(chestName, rect, 120, 60, nameSize);
         createText("Pants", rect, 0, 90, labelSize);
         createText(pantsName, rect, 120, 90, nameSize);
         createText("Ring", rect, 0, 120, labelSize);
         createText(ringName, rect, 120, 120, nameSize);
         createText("Necklace", rect, 0, 150, labelSize);
         createText(necklaceName, rect, 120, 150, nameSize);
   }

   void createCharacterSheet(Player* player)
   {
      // Gold
      // createText("Gold", detailsBox, 0, 375, 18, false);
      // createText(to!string(player.gold), detailsBox, 180, 375, 18, false);

      // Inventory
      // createText("Inventory", detailsBox, 70, 405, 18, false);
      // inventoryDisplay(player, detailsBox, 0, 430, 18, true);
      float columnSize = sfRectangleShape_getSize(descriptionBox).x / 3;
      sfRectangleShape* statusBox = createBox(descriptionBox, columnSize,
            sfRectangleShape_getSize(descriptionBox).y, 0, 0);
      sfRectangleShape* attrBox = createBox(descriptionBox, columnSize,
            sfRectangleShape_getSize(descriptionBox).y, columnSize, 0);
      sfRectangleShape* inventoryBox = createBox(descriptionBox, columnSize,
            sfRectangleShape_getSize(descriptionBox).y, columnSize * 2, 0);

      // Health & Status
      healthDisplay(cast(Character) *player, statusBox, 0, 140, 18);
      gearDisplay(player, createBox(statusBox, sfRectangleShape_getSize(statusBox).x, sfRectangleShape_getSize(statusBox).y - 350, 0, 350), 0, 170, 18);

      // Stats
      createText("Stats", attrBox);
      createText("Level", attrBox, 0, 70, 18, false);
      createText(to!string(player.level), attrBox, 180, 70, 18, false);
      createText("Experience", attrBox, 0, 95, 18, false);
      createText(format("%s / %s", to!string(player.exp),
              to!string(Stats.getMaxExp(*player))), attrBox, 150, 95, 18, false);

      // Unallocated Points
      createText("Attribute Points", attrBox, 0, 135, 18, false);
      createText(to!string(player.openAttrPoints), attrBox, 180, 135, 18, false);
      createText("Skill Points", attrBox, 0, 160, 18, false);
      createText(to!string(player.openSkillPoints), attrBox, 180, 160, 18, false);

      // Attributes
      const(string) attrColumnOne = "STR\nDEX\nPER\nINT\nCON\n";
      const(string) attrColumnTwo = format("%s\n%s\n%s\n%s\n%s", player.attr["str"],
              player.attr["dex"], player.attr["per"], player.attr["mnd"], player.attr["con"]);
      createText(attrColumnOne, attrBox, 0, 200, 18, false);
      createText(attrColumnTwo, attrBox, 180, 200, 18, false);


      createText("Inventory", inventoryBox);
      inventoryDisplay(*player, inventoryBox, 0, 60, 20, true);
   }
}
