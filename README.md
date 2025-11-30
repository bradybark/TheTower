# TheTower
Written in GDScript using the Godot Engine.

**Link to Play:**  
https://bradybark.itch.io/the-tower

### 📖 Story Basics
The player character is an aspect of a powerful mage’s soul. The mage attempted to smash through the veil separating the world from the realm of the gods. In their attempt, their soul was smashed to pieces and spread out amongst the land. The PC has no memory of this event or of their true self. The PC “wakes up” in a mysterious tower with no way of going but up.

If the Player defeats the final boss they are rewarded with some cryptic text about their future. It is revealed that the Player is drawn to the Tower and is unable to leave. They will become Corrupted by its influence, and become the final boss at the top of the Tower.

### ⚔️ Breakdown of Gameplay
The Player is shown 3 different values on their Stats Panel: HP, MP, and AP

- **HP** – The Player’s health points. This is the amount of damage the Player can take until they are defeated and have to restart the game.
- **MP** – The Player’s Mana points. This determines the Player’s ability to use certain Actions in the game.
- **AP** – The Player’s Action points. This is the amount of actions the Player can do each turn.

### 🛡️ Player Aspects
Players are allowed some major choices regarding their playstyles. The “Aspects” that the players can choose from determine their unique actions, passives, and synergies. These choices are presented to the player after the defeat of a boss.

**First choice (after boss 1):**

- **Aspect of the Mage:** Increases the player’s max MP by 10. The player also gains +10 MP on a kill.
- **Aspect of the Knight:** Increases the player’s max HP by 10. The player also gains +20 HP on a kill.

The first choice depends on whether you would like to increase your ability to cast spells, or have some more health and survivability.

**Second choice (after boss 2):**

- **Aspect of the Rogue:** Access to Poison Action. Crit Chance triples. All damaging abilities can crit.
- **Aspect of the Sentinel:** Access to Block Action. All Heals do 50% more. All spells cost 50% less.

The Rogue choice is more of a glass-cannon build. Its damage output is increased but it remains squishy. The Sentinel choice is more of a defensive choice and allows the player to heal for much more and cast spells more frequently.

The third boss does not provide an Aspect choice since they are the final boss of the game.

### 📈 XP and Progression
Each time the player defeats an enemy they absorb power from the enemy’s soul. This is shown to the player in the form of XP. Gaining XP increases your Level, which results in new Actions being made available to the player, as well as increasing the potency of their already unlocked Actions.

### 👾 Enemy Class
Each enemy inherits its structure from a default enemy class. There are five variables per enemy: HP, Damage, Crit Chance, Kill XP, and Enemy Name.

- The HP variable refers to the amount of health an enemy has
- The Damage variable refers to the base damage that the enemy will do when attacking the player
- The Crit Chance refers to the percentage of time that the enemy will do double damage
- The Kill XP refers to the experience points that will be awarded to the player upon the enemy’s defeat
- The Enemy Name variable stores the enemy’s name

Each tier of enemies is stored in an array and is shuffled each time the game wants to create a new one.

### 🛠️ Reasoning Behind Engine Choice
This was my first time using Godot and GDScript; the majority of my programming experience has been in C++. I chose to use Godot for this project because of the nature and scope of the game (Godot is great for 2D projects). Since this was a solo endeavor I had to be aware of scope creep and be reasonable in my design and aspirations.
