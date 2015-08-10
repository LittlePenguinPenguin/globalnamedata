#####
###
### Gender likelihood for names
###
#####

#' Read name data formatted as gender-year combinations and 
#'   accumulates total count per name
#'
#' Designed to be fast and flexible, allowing for rapid testing
#'
#' @param data data frame with columns for Name, years.appearing,
#'   count.female and count.male
#' @param method string passed to binom.confint
#' @param threshold numeric between 0.5 and 1 indicating the minimum proportion
#'   of male names required to classify a name as likely male. If threshold is 
#'   less than 0.5 it will be used as minimum proportion of female names
#' @param ... Additional arguments to be passed to \code{\link{binom.confint}}
#'
#' @return A data frame with the same structure but appended columns for
#'   prob.gender (a factor), estimated proportion and upper and lower bounds 
#'   for confidence intervals
#'
#' @export
#' @importFrom binom binom.confint
nameBinom <- function (data, method = "ac", threshold = 0.9, ...) 
{
    base.cols <- c("Name", "years.appearing", "count.female", 
        "count.male")
    data <- data[, names(data) %in% base.cols]
    unknown_count <- 0
    f <- function(data, threshold = 0.9, method = "ac") {
        totalcount <- as.numeric(data["count.male"]) + as.numeric(data["count.female"])
        pred <- binom.confint(as.numeric(data["count.male"]), 
            totalcount, method = method)
        prob <- pred[, "mean"]
        lower <- pred[, "lower"]
        upper <- pred[, "upper"]
        if (prob > threshold) {
            out.val <- "Male"
        }
        else if (prob < 1 - threshold) {
            out.val <- "Female"
        }
        else {
            unknown_count <<- unknown_count + 1
            trial <- rbinom(1, 10, prob)
            if (trial >= 10 * lower & trial <= 10 * upper) {
                out.val <- "Male"
            }
            else {
                out.val <- "Female"
            }
        }
        return(out.val)
    }
    gender.prediction <- apply(data, 1, f)
    gender.observed <- with(data, (count.male/(count.male + count.female)))
    print(unknown_count)
    data.pred <- data.frame(prob.gender = gender.prediction, 
        obs.male = gender.observed)
    return(cbind(data, data.pred))
}
