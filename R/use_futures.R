#' @export
use_futures <- function() {
  use_futures_for_foreach()
  use_futures_for_BiocParallel()
}

#' @importFrom R.utils isPackageLoaded
#' @importFrom R.utils isPackageInstalled
use_futures_for_foreach <- function() {
  hookfun <- function(...) {
    if (isPackageInstalled("doFuture")) {
      doFuture::registerDoFuture()
    } else {
      warning("Install the doFuture package to allow foreach to use futures for parallel operation")
    }
  }
  if (isPackageLoaded("foreach")) {
    hookfun()
  } else {
    setHook(packageEvent("foreach", "onLoad"), hookfun, "append")
  }
}

#' @importFrom R.utils isPackageLoaded
#' @importFrom R.utils isPackageInstalled
use_futures_for_BiocParallel <- function() {
  hookfun <- function(...) {
    if (isPackageInstalled("BiocParallel") &&
          isPackageInstalled("BiocParallel.FutureParam")) {
      BiocParallel::register(BiocParallel.FutureParam::FutureParam())
    } else {
      warning("Install the BiocParallel.FutureParam package to allow BiocParallel to use futures for parallel operation")
    }
  }
  if (isPackageLoaded("BiocParallel")) {
    hookfun()
  } else {
    setHook(packageEvent("BiocParallel", "onLoad"), hookfun, "append")
  }
}
