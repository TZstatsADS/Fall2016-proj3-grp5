

extract_rgb_feature <- function(img){
  # INPUT: an EBImage image object. Use EBImage::readImage to create from jpg
  # OUTPUT: a 1000-dimensional vector of color frequencies in img
  
  library("EBImage")
  
  mat <- imageData(img)
  
  rBin = seq(0, 1, length.out=10)
  gBin = seq(0, 1, length.out=10)
  bBin = seq(0, 1, length.out=10)
  
  freq_rgb = as.data.frame(table(factor(findInterval(mat[,,1], rBin), levels=1:10), 
                                 factor(findInterval(mat[,,2], gBin), levels=1:10), 
                                 factor(findInterval(mat[,,3], bBin), levels=1:10)))
  
  rgb_feature = as.numeric(freq_rgb$Freq)/(ncol(mat)*nrow(mat)) # normalization
  
  return(rgb_feature)
}
