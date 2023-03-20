# Projet Démineur :

Le but de ce projet est de créer une librairie R incluant une application Shiny permettant de jouer au démineur.Cette dernière  est un package R  qui permet la création d’applications Web notamment des jeux comme dans notre cas , elle dispose des outils puissants qui  aident  à transformer vos analyses en applications interactives .

## Règles du jeu :

1. Le jeu se présente sous forme d'une grille rectangulaire contenant des cases.

2. Les cases de cette grille peuvent être soit vides , soit contiennent  une mine.

3. Le but du jeu est de découvrir toutes les cases vides sans déclencher une mine.

4. Si une case vide est cliquée , elle révèle un nombre qui indique le nombre de cases adjacentes qui contiennent des mines (au-dessus,
en-dessous, à gauche, à droite, au-dessus à gauche, au-dessus à droite, en-dessous à gauche,
et en-dessous à droite d’elle).

5. Si la case cliquée contient une mine , le joueur perd la partie.

6. Si toutes les cases vides sont découvertes sans déclencher de mines , le joueur gagne la partie.

## Projet

- Le fichier "minesweeper2.R" permet de jouer au démineur à plusieurs niveaux (Facile, Moyen , Difficile) , ou en personnalisant votre grille selon le choix des lignes , colonnes et mines en utilisant la fonction `minesweeper` de la librairie "Rbeast".

- Le fichier "minesweeper1.R" permet de jouer au démineur en personnalisant la grille de votre jeu en utilisant la fonction `minesweeper(height, width, prob)`.


## Contact :

sarah.matoub@etu.umontpellier.fr

thizir.abchiche@etu.umontpellier.fr

## Références :

- [Mastering Shiny by O'Reilly](https://mastering-shiny.org/).

