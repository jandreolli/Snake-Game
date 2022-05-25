# MIPS Assembly Project - Snake Game

## Pour commencer

### Pré-requis

- Le simulateur ``Mars4_5.jar`` disponible ici http://courses.missouristate.edu/kenvollmar/mars/


### Démarrage

- Pour lancer l'émulateur MARS, taper cette commande dans le terminal:

```
java -jar Mars4_5.jar
```

- Charger le fichier ``snake.s``, l'assembler puis aller dans l'onglet **Tools** pour lancer **Bitmap Display** ainsi que **Keyboard and Display MMIO Simulator**.

- Dans la fenêtre **Bitmap Display**, sélectionner **16** pour **Unit Width in Pixels** et **Unit Height in Pixels** puis **256** pour **Display Width in Pixels** et **Display Height in Pixels**.

- Finalement, cliquer sur les deux widgets **Connect to MIPS** et lancer l'exécution du programme.

![snakeAffichage](https://user-images.githubusercontent.com/95167842/170217236-2b3ab8d3-c2c6-4331-b9b8-3ed539560bd5.png)

## Pour jouer au snake

### Touches directionnelles

- Dans la fenêtre **Keyboard and Display MMIO Simulator** à la rubrique **Keyboard** vous pouvez entrer les touches directionnelles:
	+ **z** _haut_ 
	+ **q** _gauche_
	+ **s** _bas_
	+ **d** _droite_
	
**NB** : le serpent ne peut pas reculer sinon cela s'apparente à du cannibalisme

### Principe du jeu

- Lorsque le serpent mange de la nourriture _(carré rose)_:
	+ le serpent grandit
	+ un nouvel obstacle _(carré rouge)_ apparaît 
	+ le score est incrémenté

### Fin du jeu
- Le jeu se termine si le serpent se mord la queue, heurte un obstacle ou un mur. 

- À la fin du jeu, le score ainsi que le niveau atteint s'affichent dans la console.


## Auteurs

* **Justine Andreolli**  _alias_ [@jandreolli](https://github.com/jandreolli)
* **Ambre Lis**  _alias_ [@ambrelis](https://github.com/ambrelis)






