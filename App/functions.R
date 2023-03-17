#Initialisation
rows = 6
cols = 8
mines = 10

replace <- function(x){
  color <- c("#99ff33", "#b3ff66", "#b3d9ff", "#cc99ff", "#ff99cc")
  if(x==-1){
    return(emoji("bomb"))
  } else{
    return(text("x", col=color))
  }
}

# Générer une grille de démineur
generate_grid <- function(rows, cols, mines) {
  grid <- matrix(0, nrow = rows, ncol = cols) 
  mine_spots <- sample(1:(rows*cols), mines)
  grid[mine_spots] <- -1
  
  for (r in 1:rows) {
    for (c in 1:cols) {
      if (grid[r, c] == -1) {
        grid[r, c]  <- "M"
        #tags$image(src=bomb_url, width="0.1cm", height="0.1cm")
        next
      }
      neighbors <- c()
      if (r > 1) {
        neighbors <- c(neighbors, grid[r - 1, c])
        if (c > 1) {
          neighbors <- c(neighbors, grid[r - 1, c - 1])
        }
        if (c < cols) {
          neighbors <- c(neighbors, grid[r - 1, c + 1])
        }
      }
      if (r < rows) {
        neighbors <- c(neighbors, grid[r + 1, c])
        if (c > 1) {
          neighbors <- c(neighbors, grid[r + 1, c - 1])
        }
        if (c < cols) {
          neighbors <- c(neighbors, grid[r + 1, c + 1])
        }
      }
      if (c > 1) {
        neighbors <- c(neighbors, grid[r, c - 1])
      }
      if (c < cols) {
        neighbors <- c(neighbors, grid[r, c + 1])
      }
      grid[r, c] <- sum(neighbors == -1)
      
      if(grid[r,c]==0){
        grid[r,c] <- ""
      }
    }
  }
  return(grid)
  
}

#Fonction pour compter le nombre de mines dans la grille
mines_count <- function(grid){
  mines <- 0
  for(r in 1:nrow(grid)){
    for(c in 1:ncol(grid)){
      if(grid[r,c]=="M"){
        mines <- mines + 1
      }
    }
  }
  return(mines)
}





# Fonction pour révéler la case sélectionnée
reveler_case <- function(grid, r, c) {
  if (grid[r, c] == "M") {
    # Si toutes les cellules contiennent une mine alors afficher game over
    grid[grid =="M"] <- emojifont::emoji("bomb")
    print("Game over!")
    return(grid)
  } else if (grid[r, c] == "") {
    # si la case est vide alors révéler les cellules adjacentes ne contenant pas de mines
    for (i in -1:1) {
      for (j in -1:1) {
        if (r+i >= 1 && r+i <= nrow(grid) && c+j >= 1 && c+j <= ncol(grid)) {
          if (grid[r+i, c+j] != "M" && grid[r+i, c+j] != "R") {
            grid[r+i, c+j] <- "R"
            grid <- reveler_case(grid, r+i, c+j)
            if (grid[r+i, c+j] == "") {
              grid[r+i, c+j] <- "R"
              grid <- reveler_case(grid, r+i, c+j)
            }
            
          }
        } 
      }
    }
  }
  grid[r, c] <- "R"
  return(grid)
}



#gérer le clic groit
clic_droit <- function(event){
  if(event$type == "click" && event$button == "right"){
    cat("Right mouse button clicked at (", event$x, ", ", event$y, ")\n")
  }
}


#fonction pour mettre à jour le nombre de drapeaux
flag <- function(grid){
  nb_flags <- 0
  for(r in 1:nrow(grid)){
    for(c in 1:ncol(grid)){
      if(clic_droit(grid[r,c])==TRUE){
         grid[r,c] <- emojifont::emoji("flag")
         print(mines_count(grid) - 1)
      }
    }
  }
}

# fonction qui met à jour la grille
update <- function(grid, r, c) {
  if (grid[r, c] == "M") {
    # Si la case contient une mine, afficher game over et retourner la grille non mise à jour
    grid[grid == "M"] <- emojifont::emoji("bomb")
    print(grid)
    print("Game over!")
    return(grid)
  } else if (grid[r, c] == "") {
    # Si la case est vide, révéler les cellules adjacentes qui ne contiennent pas de mines
    for (i in -1:1) {
      for (j in -1:1) {
        if (r+i >= 1 && r+i <= nrow(grid) && c+j >= 1 && c+j <= ncol(grid)) {
          if (grid[r+i, c+j] != "M" && grid[r+i, c+j] != "R") {
            grid[r+i, c+j] <- "R"
            update(grid, r+i, c+j)
          }
        }
      }
    }
  } else if (!is.na(as.numeric(grid[r, c]))) {
    # Si la case contient un chiffre, révéler la case et retourner la grille mise à jour
    grid[r, c] <- "R"
  }
  return(grid)
}



# Fonction pour révéler la case sélectionnée
reveler_case <- function(grid, r, c) {
  if (grid[r, c] == "M") {
    # Si toutes les cellules contiennent une mine alors afficher game over
    grid[grid == "M"] <- emojifont::emoji("bomb")
    print(grid)
    print("Game over!")
  } else if (grid[r, c] == "") {
    # si la case est vide alors révéler les cellules adjacentes ne contenant pas de mines
    for (i in -1:1) {
      for (j in -1:1) {
        if (r+i >= 1 && r+i <= nrow(grid) && c+j >= 1 && c+j <= ncol(grid)) {
          if (grid[r+i, c+j] != "M" && grid[r+i, c+j] != "R") {
            grid[r+i, c+j] <- "R"
            grid <- reveler_case(grid, r+i, c+j)
          }
        } 
      }
    }
  }
  grid[r, c] <- "R"
  return(grid)
}

jeu <- function(r, c, mines){
  grille <- generate_grid(r, c, mines)
  grille_cachee <- matrix(emojifont::emoji("flower"), nrow = r, ncol = c)
  play(grille_cachee, grille)
  
}



z <- generate_grid(10, 11, 16)