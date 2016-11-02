#############################################################
### Construct visual features for training/testing images ###
#############################################################


feature = function(img_dir, verbose=TRUE){
  # INPUT: 
  #     img_dir = directory with all the images to extract features from
  #     verbose = if true, displays progress
  # OUTPUT: matrix new_features (format images*features)
  
  library("EBImage")

  extract_rgb_feature <- function(img){
    # INPUT: an EBImage image object. Use EBImage::readImage to create from jpg
    # OUTPUT: a 1000-dimensional vector of color frequencies in img

    mat = imageData(img)
    
    rBin = seq(0, 1, length.out=10)
    gBin = seq(0, 1, length.out=10)
    bBin = seq(0, 1, length.out=10)
    
    freq_rgb = as.data.frame(table(factor(findInterval(mat[,,1], rBin), levels=1:10), 
                                   factor(findInterval(mat[,,2], gBin), levels=1:10), 
                                   factor(findInterval(mat[,,3], bBin), levels=1:10)))
    
    rgb_feature = as.numeric(freq_rgb$Freq)/(ncol(mat)*nrow(mat)) # normalization
    
    return(rgb_feature)
  }
  
  
  files = list.files(img_dir)

  new_features = matrix(NA, length(files), 1000)
  for(i in 1:length(files)){
    
    if(verbose)
      cat(files[i], '\n')
    
    img = readImage(paste(img_dir, files[i], sep=''))

    new_features[i,] = extract_rgb_feature(img)
  }
  
  return(new_features)
}


