#' Use StateFace font for labeling of States in charts
#'
#' Allows you to use ProPublica's [StateFace font](https://propublica.github.io/stateface/)
#' in charts.
#'
#' @inheritParams ggplot2::geom_text
#'
#' @export
#'
#' @examples
#'\dontrun{
#' library(ggplot2)
#' ggplot(usa_arrests, aes(murder, assault, label = state)) +
#'   geom_stateface()
#'
#' ggplot(usa_arrests, aes(murder, assault, label = state, color = urban_pop)) +
#'   geom_stateface() +
#'   scale_color_viridis_c()
#' }
#'
#' @source \url{https://propublica.github.io/stateface/}
#' @importFrom rlang abort
#' @importFrom ggplot2 position_nudge layer
geom_stateface <- function(mapping = NULL, data = NULL, stat = "identity",
                           position = "identity", ..., parse = FALSE,
                           nudge_x = 0, nudge_y = 0, check_overlap = FALSE,
                           na.rm = FALSE, show.legend = NA,
                           inherit.aes = TRUE) {

  if (!missing(nudge_x) || !missing(nudge_y)) {
    if (!missing(position)) {
      abort("You must specify either `position` or `nudge_x`/`nudge_y`.")
    }
    position <- position_nudge(nudge_x, nudge_y)
  }
  layer(data = data, mapping = mapping, stat = stat, geom = GeomStateFace,
        position = position, show.legend = show.legend,
        inherit.aes = inherit.aes,
        params = list(parse = parse, check_overlap = check_overlap,
                      family = "StateFace", na.rm = na.rm, ...))
}

#' @rdname fontscales-extensions
#' @format NULL
#' @usage NULL
#' @export
#' @importFrom ggplot2 aes
#' @importFrom grid textGrob gpar
GeomStateFace <- ggplot2::ggproto("GeomStateFace", ggplot2::Geom,
                    required_aes = c("x", "y", "label"),

                    default_aes = ggplot2::aes(
                      colour = "black", size = 3.88, angle = 0, hjust = 0.5,
                      vjust = 0.5, alpha = NA, family = "", fontface = 1, lineheight = 1.2
                    ),

                    draw_panel = function(data, panel_params, coord, parse = FALSE,
                                          na.rm = FALSE, check_overlap = FALSE) {
                      lab <- data$label
                      lab <- stateface_key[lab]
                      if (parse) {
                        lab <- parse_safe(as.character(lab))
                      }

                      data <- coord$transform(data, panel_params)
                      if (is.character(data$vjust)) {
                        data$vjust <- compute_just(data$vjust, data$y)
                      }
                      if (is.character(data$hjust)) {
                        data$hjust <- compute_just(data$hjust, data$x)
                      }

                      textGrob(
                        lab,
                        data$x, data$y, default.units = "native",
                        hjust = data$hjust, vjust = data$vjust,
                        rot = data$angle,
                        gp = gpar(
                          col = alpha(data$colour, data$alpha),
                          fontsize = data$size * .pt,
                          fontfamily = data$family,
                          fontface = data$fontface,
                          lineheight = data$lineheight
                        ),
                        check.overlap = check_overlap
                      )
                    },

                    draw_key = ggplot2::draw_key_text
)

# Imported from ggplot2
compute_just <- function(just, x) {
  inward <- just == "inward"
  just[inward] <- c("left", "middle", "right")[just_dir(x[inward])]
  outward <- just == "outward"
  just[outward] <- c("right", "middle", "left")[just_dir(x[outward])]

  unname(c(left = 0, center = 0.5, right = 1,
           bottom = 0, middle = 0.5, top = 1)[just])
}

just_dir <- function(x, tol = 0.001) {
  out <- rep(2L, length(x))
  out[x < 0.5 - tol] <- 1L
  out[x > 0.5 + tol] <- 3L
  out
}

stateface_key <- c(
  "Alabama" = "B",
  "Alaska" = "A",
  "Arizona" = "D",
  "Arkansas" = "C",
  "California" = "E",
  "Colorado" = "F",
  "Connecticut" = "G",
  "Delaware" = "H",
  "D.C." = "y",
  "Florida" = "I",
  "Georgia" = "J",
  "Hawaii" = "K",
  "Idaho" = "M",
  "Illinois" = "N",
  "Indiana" = "O",
  "Iowa" = "L",
  "Kansas" = "P",
  "Kentucky" = "Q",
  "Louisiana" = "R",
  "Maine" = "U",
  "Maryland" = "T",
  "Massachusetts" = "S",
  "Michigan" = "V",
  "Minnesota" = "W",
  "Mississippi" = "Y",
  "Missouri" = "X",
  "Montana" = "Z",
  "Nebraska" = "c",
  "Nevada" = "g",
  "New Hampshire" = "d",
  "New Jersey" = "e",
  "New Mexico" = "f",
  "New York" = "h",
  "North Carolina" = "a",
  "North Dakota" = "b",
  "Ohio" = "i",
  "Oklahoma" = "j",
  "Oregon" = "k",
  "Pennsylvania" = "l",
  "Rhode Island" = "m",
  "South Carolina" = "n",
  "South Dakota" = "o",
  "Tennessee" = "p",
  "Texas" = "q",
  "USA" = "z",
  "Utah" = "r",
  "Vermont" = "t",
  "Virginia" = "s",
  "Washington" = "u",
  "West Virginia" = "w",
  "Wisconsin" = "v",
  "Wyoming" = "x"
)
