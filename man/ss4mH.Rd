% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ss4mH.R
\name{ss4mH}
\alias{ss4mH}
\title{The required sample size for testing a null hyphotesis for a single mean}
\usage{
ss4mH(N, mu, mu0, sigma, DEFF = 1, conf = 0.95, power = 0.8, plot = FALSE)
}
\arguments{
\item{N}{The population size.}

\item{mu}{The population mean of the variable of interest.}

\item{mu0}{The value to test for the single mean.}

\item{sigma}{The population variance of the variable of interest.}

\item{DEFF}{The design effect of the sample design. By default \code{DEFF = 1}, which corresponds to a simple random sampling design.}

\item{conf}{The statistical confidence. By default \code{conf = 0.95}.}

\item{power}{The statistical power. By default \code{power = 0.80}.}

\item{plot}{Optionally plot the effect against the sample size.}
}
\description{
This function returns the minimum sample size required for testing a null hyphotesis regarding a single mean
}
\details{
We assume that it is of interest to test the following set of hyphotesis:
\deqn{H_0: mu - mu_0 = 0 \ \ \ \ vs. \ \ \ \ H_a: mu - mu_0 = D \neq 0 }
Note that the minimun sample size, restricted to the predefined power \eqn{\beta} and confidence \eqn{1-\alpha}, is defined by: 
\deqn{n = \frac{S^2}{\frac{D^2}{(z_{1-\alpha} + z_{\beta})^2}+\frac{S^2}{N}}}
Where \eqn{S^2=\sigma^2 * DEFF} and \eqn{\sigma^2} is the population variance of the varible of interest.
}
\examples{
ss4mH(N = 10000, mu = 500, mu0 = 505, sigma = 100)
ss4mH(N = 10000, mu = 500, mu0 = 505, sigma = 100, plot=TRUE)
ss4mH(N = 10000, mu = 500, mu0 = 505, sigma = 100, DEFF = 2, plot=TRUE)
ss4mH(N = 10000, mu = 500, mu0 = 505, sigma = 100, conf = 0.99, power = 0.9, DEFF = 2, plot=TRUE)

#############################
# Example with BigLucy data #
#############################
data(BigLucy)
attach(BigLucy)

N <- nrow(BigLucy)
mu <- mean(Income)
sigma <- sd(Income)

# The minimum sample size for testing 
# H_0: mu - mu_0 = 0   vs.   H_a: mu - mu_0 = D = 15
D = 15 
mu0 = mu - D 
ss4mH(N, mu, mu0, sigma, conf = 0.99, power = 0.9, DEFF = 2, plot=TRUE)

# The minimum sample size for testing 
# H_0: mu - mu_0 = 0   vs.   H_a: mu - mu_0 = D = 32
D = 32
mu0 = mu - D 
ss4mH(N, mu, mu0, sigma, conf = 0.99, power = 0.9, DEFF = 3.45, plot=TRUE)
}
\references{
Gutierrez, H. A. (2009), \emph{Estrategias de muestreo: Diseno de encuestas y estimacion de parametros}. Editorial Universidad Santo Tomas
}
\seealso{
\code{\link{e4p}}
}
\author{
Hugo Andres Gutierrez Rojas <hagutierrezro at gmail.com>
}
