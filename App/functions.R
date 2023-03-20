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
         grid[r,c] <- "-2"
         print(mines_count(grid) - 1)
      }
    }
  }
}


flag_cell <- function(cell, grid){
  r <- nrow(grid)
  c <- ncol(grid)
  fl <- matrix(data = paste0("-2",1:(r*c)), nrow = r, ncol = c)
  gg <- matrix(data = paste0(emoji("hibiscus"),1:(r*c)), nrow = r, ncol = c)

}



#grille cachée 
grid_cachee <- function(grid, r, c){
  r <- nrow(grid)
  c <- ncol(grid)
  grid <- matrix(0, nrow = r, ncol = c)
  grid[] <- seq_along(grid)
    
 return(grid) 
}

#obtenir l'id de la cellule
cell_id <- function(grid, r, c){
  n_row <- nrow(grid)
  n_col <- ncol(grid)
  #calculer l'id de la cellule
  cell_id <-  (r - 1) * n_col + c
  return(cell_id)
}

#obtenir les indices de la cellule
get_indices <- function(grid, cell_id) {
  nrow <- dim(grid)[1]
  ncol <- dim(grid)[2]
  row <- ((cell_id - 1) %/% ncol) + 1
  col <- ((cell_id - 1) %% ncol) + 1
  return(list(row=row, col=col))
}


#mettre à jour la grille 
maj_grille_case <- function(grid, r, c, grille_cachee) {
  if (grid[r, c] == "M") {
    grille_cachee[grid == "M"] <- "-1"
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
}}

# fonction pour révéler la case
reveler_case <- function(grid, r, c, grille_cachee) {
  
  grille_cachee <- grid_cachee(grid)
  
  if (grid[r, c] == "M") {
    # Si toutes les cellules contiennent une mine alors afficher game over
    grille_cachee[grid=="M"] <- "-1"
    print("Game over!")
    
  } else if(grid[r, c] == "") {
    
    grille_cachee[r, c] <- grid[r,c]
    
    max_revealed <- 0
    for (i in -1:1) {
      for (j in -1:1) {
        if (i != 0 || j != 0) { # condition supp pour sauter la cellule actuelle
          if (r+i >= 1 && r+i <= nrow(grid) && c+j >= 1 && c+j <= ncol(grid)) {
            if (grid[r+i, c+j] != "M" && grille_cachee[r+i, c+j] == "") {
              # recursively reveal adjacent cells
              revealed <- reveler_case(grid, r+i, c+j, grille_cachee)
              grille_cachee <- revealed
              
              # count the number of revealed cells
              num_revealed <- sum(revealed != "")
              
              # update max_revealed if the current count is larger
              if (num_revealed > max_revealed) {
                max_revealed <- num_revealed
              }
            } else if (grid[r+i, c+j] != "M") {
              # if the adjacent cell does not contain a mine, reveal it
              grille_cachee[r+i, c+j] <- grid[r+i, c+j]
            }
          }
        }
}}}}


update <- function(grid){
  for(r in 1:nrow(grid)){
    for(c in 1:ncol(grid)){
      if(reveler_case(grid, r, c)==TRUE && grid[r,c]!=M){
        grid <- grid[r,c]
        #finish

      }
    }
  }
}

#révéler case adjacentes
reveal_adjacent <- function(grid, r, c, grille_cachee, max_revealed) {
  # get coordinates of all adjacent cells that do not contain mines
  adj_coords <- which(grid[r-1:r+1, c-1:c+1] != "M", arr.ind = TRUE)
  adj_coords[,1] <- adj_coords[,1] + r - 1
  adj_coords[,2] <- adj_coords[,2] + c - 1
  
  # choose up to max_revealed adjacent cells to reveal
  if (nrow(adj_coords) > max_revealed) {
    adj_coords <- adj_coords[sample(nrow(adj_coords), max_revealed),]
  }
  
  # reveal the chosen adjacent cells
  for (i in 1:nrow(adj_coords)) {
    grille_cachee[adj_coords[i,1], adj_coords[i,2]] <- grid[adj_coords[i,1], adj_coords[i,2]]
  }
  
  return(grille_cachee)
}



######################################################
#test des fonctions ci-dessus avant de les mettre dans shiny et tout faire sauter

# play_minesweeper <- function(grid) {
#   grille_cachee <- grid_cachee(grid)
#   gameOver <- FALSE
#   while (!gameOver) {
#     print(grille_cachee)
#     r <- as.integer(readline(prompt="Enter row: "))
#     c <- as.integer(readline(prompt="Enter column: "))
#     # if (grille_cachee[r, c] != " ") {
#     #   print("This cell has already been revealed. Please choose another one.")
#     # } else {
#     grille_cachee <- reveler_case(grid, r, c, grille_cachee )
#     #grille_cachee <- reveler_case(as.matrix(grid), r, c, grille_cachee)
#     maj_grille_case(grid, r, c, grille_cachee)
#       if (any(grille_cachee == "M")) {
#          gameOver <- TRUE
#         print("Game over!") }
#       
#   }
#   
#   replay <- readline(prompt = "Do you want to replay? (y/n) ")
#   if(replay=="y"){
#     play_minesweeper(grid)
#   } else {
#     quit(save="default")
#   }
#   }



# z <- generate_grid(4, 4, 10)
# y <- grid_cachee(z)




