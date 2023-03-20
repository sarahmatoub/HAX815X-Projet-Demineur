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

### Dans R : 

- Dans le répertoir *minesweeper*, vous trouverez le code pour le jeu du démineur (fichier `minesweeper.R`), qui correspond à la fonction implémentée dans la bibliothèque Rbeast (disponible dans la section *Références*). 

Si vous exécutez ce code et que vous saisissez la commande suivante dans la console de R studio :

```bash
demineur(width= 15, height=10, prob=0.5)
```
Une fenêtre va s'afficher et vous permettra de jouer au démineur sur `R`.

Vous poussez également lancer l'application shiny disponible dans le fichier `minesweeper_app.R` qui permet de jouer au démineur en personnalisant la grille de votre jeu en utilisant la fonction `minesweeper(height, width, prob)` de la librairie `Rbeast`.

## Dans Shiny:

- Avant de lancer l'application , assurez vous d'avoir installé toutes librairies nécessaires , grâce à la commande suivante :

```bash
while IFS=" " read -r package version; 
do 
  Rscript -e "devtools::install_version('"$package"', version='"$version"')"; 
done < "requirements.txt"
```

Ensuite , vous pouvez la lancer dans le fichier `demineur.R`.


## Contact :

sarah.matoub@etu.umontpellier.fr

thizir.abchiche@etu.umontpellier.fr

## Références :

- [Mastering Shiny by O'Reilly](https://mastering-shiny.org/).

- [Code source de la fonction minesweeper](https://rdrr.io/cran/Rbeast/src/R/minesweeper.r).

