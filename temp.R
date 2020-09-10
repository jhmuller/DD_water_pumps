
tests <- function(){
  
  result = tryCatch(
    {
      destfile <- "junk"
      url = "https://drivendata-prod.s3.amazonaws.com/data/7/public/SubmissionFormat.csv?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIARVBOBDCY3EFSLNZR%2F20200907%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200907T134912Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&X-Amz-Signature=49234131d76a37636ad253669058d6b7b6eb91ecb5506cb20f00af8328a55c57"
      res <- download.file("http://github.com/jhmuller/DD_water_pumps/x_values.csv", 
                           destfile="junk", 
                           method="auto", quiet = FALSE, 
                           mode = "w",
                           cacheOK = TRUE,
                           extra = getOption("download.file.extra"),
                           headers = NULL)
    }  , warning = function(w) {
      print(paste("Warning", w))
      print(paste("Deleting file ", destfile))
      file.remove(destfile)
      return (1)
    }, error = function(e) {
      print("Error")
      print(e)
      print(paste("Deleting file ", destfile))
      file.remove(destfile)  
      return (-1)
    }, finally = {
      if (file.exists(destfile)){
        print("Cleaning up")
        return (0)
      }
    } # finally
  )
  
  downloader::download
  url <- "http://en.wikipedia.org"
  destfile <- "junk"
  res <- download(url, destfile=destfile)
  res
  x <- httr::GET("http://en.wikipedia.org/nothing")
  x
  curl = getCurlHandle()
  x = getURL("https://en.wikipedia.org/asdfasdfasdf", curl = curl)
  getCurlInfo(curl)$response.code
  options("warn")
  result
  file.exits("junk")
}

