module characters.player;
import details.attributes;
import details.gear;
import items.weapons.unarmed;
import items.armors.linenShirt;
import characters.character;
import actions.attack;
import actions.action;
import actions.escape;

class Player : Character
{
public:
   this()
   {

      attr["str"] = 1;
      attr["dex"] = 1;
      attr["per"] = 1;
      attr["mnd"] = 1;
      attr["con"] = 3;

      gear.weapon = new Unarmed();
      gear.chest = new LinenShirt();

      combatActions = [new Attack(), new Flee()];
   }

   Action[] combatActions;
}
