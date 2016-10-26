#############################################################
### Construct visual features for training/testing images ###
#############################################################


feature = function(img_dir){
  # INPUT: directory with all the images to extract features from
  # OUTPUT: 
  
  library("EBImage")
  
  files = list.files(img_dir)

  for(i in 1:length(files)){
    
    img = readImage(paste(img_dir, files[i], sep=''))

    rgb_feature = extract_rgb_feature(img)
  }
  

  ### store vectorized pixel values of images
  dat <- array(dim=c(n_files, n_r*n_c)) 
  for(i in 1:n_files){
    img <- readImage(paste0(img_dir, img_name, "_", i, ".jpg"))
    dat[i,] <- as.vector(img)
  }
  
  ### output constructed features
  if(!is.null(data_name)){
    save(dat, file=paste0("./output/feature_", data_name, ".RData"))
  }
  return(dat)
}
