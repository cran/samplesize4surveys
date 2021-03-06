#' @import TeachingSampling
#' @export
#'
#' @title
#' The required sample size for estimating a single proportion based on a logaritmic transformation of the estimated proportion
#' @description
#' This function returns the minimum sample size required for estimating a single proportion subjecto to predefined errors.
#' @details
#' As for low proportions, the coefficient of variation tends to infinity, it is customary to use
#' a simmetrycal transformation of this measure (based on the relative standard error RSE) to report
#' the uncertainity of the estimation. This way, if \eqn{p \leq 0.5}, the transformed CV will be:
#' \deqn{RSE(-ln(p))= \frac{SE(p)}{-ln(p)*p}}
#' Otherwise, when \eqn{p > 0.5}, the transformed CV will be:
#' \deqn{RSE(-ln(1-p))= \frac{SE(p)}{-ln(1-p)*(1-p)}}
#' Note that, when \eqn{p \leq 0.5} the minimun sample size to achieve a particular coefficient of variation \eqn{cve} is defined by:
#' \deqn{n = \frac{S^2}{P^2cve^2+\frac{S^2}{N}}}
#' When \eqn{p > 0.5} the minimun sample size to achieve a particular coefficient of variation \eqn{cve} is defined by:
#' \deqn{n = \frac{S^2}{P^2cve^2+\frac{S^2}{N}}}
#'
#' @author Hugo Andres Gutierrez Rojas <hagutierrezro at gmail.com>
#' @param N The population size.
#' @param P The value of the estimated proportion.
#' @param DEFF The design effect of the sample design. By default \code{DEFF = 1}, which corresponds to a simple random sampling design.
#' @param cve The maximun coeficient of variation that can be allowed for the estimation.
#' @param plot Optionally plot the errors (cve and margin of error) against the sample size.
#'
#' @references
#' Gutierrez, H. A. (2009), \emph{Estrategias de muestreo: Diseno de encuestas y estimacion de parametros}. Editorial Universidad Santo Tomas
#' @seealso \code{\link{ss4p}}
#' @examples
#' ss4pLN(N=10000, P=0.8, cve=0.10)
#' ss4pLN(N=10000, P=0.2, cve=0.10)
#' ss4pLN(N=10000, P=0.7, cve=0.05, plot=TRUE)
#' ss4pLN(N=10000, P=0.3, cve=0.05, plot=TRUE)
#' ss4pLN(N=10000, P=0.05, DEFF=3.45, cve=0.03, plot=TRUE)
#' ss4pLN(N=10000, P=0.95, DEFF=3.45, cve=0.03, plot=TRUE)
#'
#' ##########################
#' # Example with Lucy data #
#' ##########################
#'
#' data(Lucy)
#' attach(Lucy)
#' N <- nrow(Lucy)
#' P <- prop.table(table(SPAM))[1]
#' # The minimum sample size for simple random sampling
#' ss4pLN(N, P, DEFF=1, cve=0.03, plot=TRUE)
#' # The minimum sample size for a complex sampling design
#' ss4pLN(N, P, DEFF=3.45, cve=0.03, plot=TRUE)


ss4pLN <- function(N, P, DEFF = 1, cve = 0.05, plot = FALSE) {
  S2 <- P * (1 - P) * DEFF
  if (P <= 0.5) {
    n.cve <- S2 / (P^2 * (log(P))^2 * cve^2 + (S2 / N))
  }
  if (P > 0.5) {
    n.cve <- S2 / ((1 - P)^2 * (log(1 - P))^2 * cve^2 + (S2 / N))
  }
  if (plot == TRUE) {
    nseq <- seq(100, N, 10)
    cveseq <- rep(NA, length(nseq))

    for (k in 1:length(nseq)) {
      fseq <- nseq[k] / N
      varseq <- (1 / nseq[k]) * (1 - fseq) * S2
      if (P <= 0.5) {
        cveseq[k] <- 100 * sqrt(varseq) / (-log(P) * P)
      }
      if (P > 0.5) {
        cveseq[k] <- 100 * sqrt(varseq) / (-log(1 - P) * (1 - P))
      }
    }

    par(mfrow = c(1, 2))

    plot(nseq, cveseq,
      type = "l", lty = 2, pch = 1, col = 3,
      ylab = "Transformed coefficient of variation %", xlab = "Sample size"
    )
    points(n.cve, 100 * cve, pch = 8, bg = "blue")
    abline(h = 100 * cve, lty = 3)
    abline(v = n.cve, lty = 3)
    
    pseq <- seq(0.01, 0.99, 0.01)
    ncveseq <- rep(NA, length(pseq))
    
    for (k in 1:length(pseq)) {
      fseq <- nseq[k] / N
      S2seq <- pseq[k] * (1 - pseq[k]) * DEFF
      if (pseq[k] <= 0.5) {
        ncveseq[k] <- S2seq / (pseq[k]^2 * (log(pseq[k]))^2 * cve^2 + (S2seq / N))
      }
      if (pseq[k] > 0.5) {
        ncveseq[k] <- S2seq / ((1 - pseq[k])^2 * (log(1 - pseq[k]))^2 * cve^2 + (S2seq / N))
      }
    }
    
    plot(pseq, ncveseq,
         type = "l", lty = 2, pch = 1, col = 3,
         ylab = "Required sample size", xlab = "Estimated proportion",
    )
    points(P, n.cve, pch = 8, bg = "blue")
    abline(h = n.cve, lty = 3)
    abline(v = P, lty = 3)
  }
  result <- ceiling(n.cve)
  result
}
