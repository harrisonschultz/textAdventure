module items.weapons.attack;

import types.damage;
import details.stats;
import state.state;

struct Attack
{
   float damageModifier;
   DamageTypes damageType;
   string name;

   State onExecute(State state) {


      return state;
   }
}
