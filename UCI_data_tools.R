library(stringi)

# Return a list of file paths for the necessary UCI HAR datasets
get_fpaths <- function(dpath='./Data/UCI HAR Dataset/',
                       testdir='test', traindir='train'){
  files <- c('features', 'subject_train','X_train','y_train',
             'subject_test','X_test','y_test')
  xpath <- list('dpath'=dpath, 'testdir'=testdir, 'traindir'=traindir)

  for (i in seq_along(xpath)){
    f <- xpath[i]; endslash <- stri_endswith_fixed(f,'/')
    if (f %in% c('train', 'test')) f <- xpath$dpath %s+% f
    if (!endslash) f <- f %s+% '/'
    xpath[i] <- f
  }
  for (f in files){
    if (stri_endswith_fixed(f,'train')) {
      fpath <- xpath$traindir %s+% f
    } else if (stri_endswith_fixed(f,'test')){
      fpath <- xpath$testdir %s+% f
    } else fpath <- xpath$dpath %s+% f
    xpath[f] <- fpath %s+% '.txt'
  }
  return(xpath)
}

# Determine if file paths are valid and exist
checkData <- function(fpaths){
  for (path in fpaths){
    if (!(file.exists(path)|dir.exists(path))){
      print(paste('Invalid Path:', path))
      return(F)
    }
  }
  return(T)
}

# Download UCI Har datasets from source
dlRawData <- function(fname='raw_data.zip'){
  dlPath <- './Data' %s+% '/' %s+% fname
  src_url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  if (!dir.exists('./Data')){
    dir.create('./Data')
  }
  if (!file.exists(dlPath)){
    download.file(src_url, dlPath)
  } else {
    fpathMD5_RDS <- './Data/rawdataMD5.RDS'
    if(is.function(tools::md5sum)&file.exists(fpathMD5_RDS)){
      existingZipMD5 <- tools::md5sum(dlPath)
      validMD5  <- readRDS(fpathMD5_RDS)
      if(existingZipMD5!=validMD5){
        download.file(src_url, dlPath)
      }
    } else {
      download.file(src_url, dlPath)
    }
  }
  unzip(dlPath, exdir = './Data', overwrite = T)
  print('Data unzipped..')
  return(T)
}

# Check if datasets for analysis are valid; if not, download it
checkDataOrDl <- function(dpath='./Data/UCI HAR Dataset/',
                          testdir='test', traindir='train'){
  fpaths <- get_fpaths(dpath, testdir, traindir)
  okData <- checkData(fpaths)
  if (!okData) {
    defaultFpaths <- get_fpaths()
    if (checkData(defaultFpaths)) {
      return(defaultFpaths)
    } else {
      dlRawData()
      if (checkData(defaultFpaths)) {
        dlPath <- './Data/raw_data.zip'
        if (file.exists(dlPath) & is.function(tools::md5sum)) {
          dlMD5 <- tools::md5sum(dlPath)
          if (!is.na(dlMD5)){
            saveRDS(dlMD5, './Data/rawdataMD5.RDS')
          }
        }
        return(defaultFpaths)
      } else return(F)
    }
  }
  return(fpaths)
}
