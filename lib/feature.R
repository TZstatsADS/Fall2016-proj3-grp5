#############################################################
### Construct visual features for training/testing images ###
#############################################################


feature = function(img_dir){
  # INPUT: directory with all the images to extract features from
  # OUTPUT: matrix new_features (format images*features)
  
  library("EBImage")
  source('./lib/extract_rgb_feature.R')
  
  files = list.files(img_dir)

  new_features = matrix(NA, length(files),1000)
  for(i in 1:length(files)){
    
    img = readImage(paste(img_dir, files[i], sep=''))

    new_features[i,] = extract_rgb_feature(img)
  }
  
  return(new_features)
}
