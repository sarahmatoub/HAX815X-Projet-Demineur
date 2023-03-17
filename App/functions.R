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

#Fonction pour compter les mines
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

reveler_case <- function(grid , r, c){
  #si la case contient une mine 
  if(grid[r,c]=="M"){
    grid[grid=="M"] <- emojifont::emoji("bomb")
    print(grid)
    print("Game over!")
    }
    if(grid[r,c]!="M" || grid[r,c]!=""){
    return(grid[r,c])
    }
  if(grid[r,c]==""){
    for(i in -1:1){
      for(j in -1:1){
        if(grid[r+i, c+j]==""){
          reveler_case(grid, r+i, c+j)
        }
      }
    }
  }
  
}



reveler_case <- function(grid, r, c) {
  if (grid[r, c] == "M") {
    grid[grid == "M"] <- emojifont::emoji("bomb")
    print(grid)
    print("Game over!")
  } else if (grid[r, c] != "" || r <= 0 || c <= 0 ||
             r > nrow(grid) || c > ncol(grid)) {
    return(grid[r, c])
  } else {
    # Count the number of mines in the immediate neighborhood
    mines <- sum(grid[(r-1):(r+1), (c-1):(c+1)] == "M")
    
    if (mines > 0) {
      # If there are adjacent mines, reveal the count and return the grid
      grid[r, c] <- mines
      return(grid)
    } else {
      # If there are no adjacent mines, reveal the cell and recursively reveal
      # all adjacent cells that are not mines
      grid[r, c] <- "*"
      for (i in -1:1) {
        for (j in -1:1) {
          grid <- reveler_case(grid, r+i, c+j)
        }
      }
      return(grid)
    }
  }
}







z <- generate_grid(10, 12, 16)

