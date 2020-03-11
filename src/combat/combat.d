module combat.combat;

import characters.character;
import items.weapons.weapon;
import details.stats;
import std.math;
import std.conv;

class Combat {

   static short attack (Character victim, Character attacker, short attackIndex) {
      double damage = 0;
      
      double incomingDamage = Stats.calcAttackDamage(attacker.gear.weapon, attackIndex ,attacker);
      double mitigatedDamage = Stats.calcPreventedDamage(attacker.gear.weapon, attackIndex ,victim);

      damage = incomingDamage - mitigatedDamage;

      // Damage cannot heal you lol
      if (damage < 0) {
         damage = 0;
      }
      
      return to!short(round(damage));
   }
}




// module.exports.combat = {
//   getActions: character => {
//     const extraActions = [];
//     return ["attack", "defend", ...extraActions, "flee"];
//   },

//   getAttackActions: character => {
//     const weapon = require(`./weapons/${character.weapon}`);
//     return weapon.attacks;
//   },

//   attack: (victim, attacker, weapon, attack) => {
//     const atk = weapon[attack];
//     //TODO: add dodge here
//     const damage =
//       stats[atk.dmgType + "Damage"](attacker) -
//       stats[atk.dmgType + "Defense"](victim);
//     return damage;
//   },

//   enemyAttack: (victim, attacker, attack) => {
//     console.log(attacker.attacks);
//     console.log(attack);
//     console.log(attacker.attacks[attack].dmgType);
//     const damage =
//       stats[attacker.attacks[attack].dmgType + "Damage"](attacker) -
//       stats[attacker.attacks[attack].dmgType + "Defense"](victim);

//     return damage;
//   },

//   wrapUpStatus: (player, enemies) => {
//     if (player.health <= 0) {
//       return "You were defeated. You follow the light and wake up back at camp.";
//     } else {
//       let exp = 0;
//       enemies.forEach(e => (exp += e.awards.exp));
//       return `Victory!, you gained ${exp} exp\nCurrent Exp: ${exp}/${stats.expToLevel(
//         player
//       )}`;
//     }
//   },

//   wrapUp: state => {
//     const { player, enemies } = state;
//     if (player.health <= 0) {
//       state.location = "plains";
//       return state;
//     } else {
//       let exp;
//       enemies.forEach(e => (exp += e.awards.exp));
//       player.exp += exp;
//       return state;
//     }
//   },

//   getCombatStatus: (player, enemies) => {
//     let status = `You: `;
//     const playerHealth = `${player.health}/${stats.health(player)}`;

//     if (player.health > stats.health(player) / 4) {
//       playerHealth.red;
//     } else if (player.health > stats.health(player) / 2) {
//       playerHealth.yellow;
//     } else {
//       playerHealth.green;
//     }

//     status += playerHealth;

//     enemies.map(e => {
//       const enemyHealth = `${e.health}/${stats.health(e)}`;

//       if (e.health > stats.health(e) / 4) {
//         enemyHealth.red;
//       } else if (e.health > stats.health(e) / 2) {
//         enemyHealth.yellow;
//       } else {
//         enemyHealth.green;
//       }

//       status += `     ${e.name}: ${enemyHealth}`;
//     });

//     return status;
//   }
// };
