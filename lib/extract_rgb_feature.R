

extract_rgb_feature <- function(img){
  # INPUT: an EBImage image object. Use EBImage::readImage to create from jpg
  # OUTPUT: a 1000-dimensional vector of color frequencies in img
  
  library("EBImage")
  
  mat <- imageData(img)
  
  nR = 10
  nG = 10
  nB = 10

  rBin = seq(0, 1, length.out=nR)
  gBin = seq(0, 1, length.out=nG)
  bBin = seq(0, 1, length.out=nB)
  
  freq_rgb = as.data.frame(table(factor(findInterval(mat[,,1], rBin), levels=1:nR), 
                                  factor(findInterval(mat[,,2], gBin), levels=1:nG), 
                                  factor(findInterval(mat[,,3], bBin), levels=1:nB)))
  
  rgb_feature = as.numeric(freq_rgb$Freq)/(ncol(mat)*nrow(mat)) # normalization
  
  return(rgb_feature)
}
