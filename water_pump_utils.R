

plot_col <- function(df, col){
  print(col)
  print(head(df[[col]]))
  if (class(df[[col]]) == "numeric"){
    print("density")
    ggplot(df, aes(x = .data[[col]])) + #{{col}})) + 
      geom_density() + 
      coord_flip()
  } else {
    print("histogram")
    get_counts(df, col)
  ggplot(df, aes(x = .data[[col]])) + #{{col}})) + 
    geom_histogram(stat="count") + 
    coord_flip()
  #ggplot(df, aes(x = {{col}})) + 
  #  geom_bar() + 
  #  coord_flip()
  }
}

ctab <- function(df, col1, col2){
  res <- xtabs(as.formula(paste("~", col1, "+", col2)), df)
  return (res)
}

assoc <- function(df, col1, col2){
  form1 <- as.formula(paste(col1 , " ~ ", col2))
  form2 <- as.formula(paste(col2, " ~ ", col1))
  s1 <- pw.assoc(form1 , df)
  s2 <- pw.assoc(form2, df)
  s <- cbind(s1, s2)
  colnames(s) <- c(form1, form2)
  s <- s[c("lambda", "tau", "U"), ]
  s
}

get_counts <- function(df, col){
  tmp <- count(df, .data[[col]], sort=TRUE)
  tmp$pct <- tmp$n/dim(df)[1]
  #sort(unique(x_train$construction_year))
  tmp$cumpct <- cumsum(tmp$pct)
  tmp
}

unique_vals <- function(df, cols=NULL){
  
  if (is.null(cols)){ tdf = df}
  else {tdf = df[cols] }
  for (i in seq_along(colnames(tdf))){
    col = colnames(tdf)[i]
    nuni = length(unique(tdf[[col]]))
    class_ = class(tdf[[col]])
    print(paste(col, nuni, class_))
  }
}
