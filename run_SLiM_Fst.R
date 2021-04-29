#!/usr/bin/env Rscript

suppressMessages(library(tidyverse))
suppressMessages(library(optparse))

runSLiM <- function(seed, freq1, freq2, model_name, slim_model)
{
  out <- paste0(model_name, "_freq1-", freq1, "_freq2-", freq2, "_seed-", seed)
    output <- system2(slim_build, c(
      "-d", paste0("freq1=", freq1),
      "-d", paste0("freq2=", freq2),
      "-d", paste0("out='\"", out, "\"'"),
      slim_model))
}

option_list <- list(
  make_option("--seed", type="character", default=1,
              help="seed start, from 1 [default %default]"),
  make_option("--freq1", type="character", default=1,
              help="P1 allele frequency, [default %default]"),
  make_option("--freq2", type="character", default=0,
              help="P2 allele frequency, [default %default]"),
  make_option(c("-o","--out"), type="character", default="./",
              help="path/to/out_directory/ [default %default]"),
  make_option("--slim_dir", type="character", default=NULL,
              help="path/to/slim"),
  make_option("--slim_model", type="character", default=NULL,
              help="path/to/slim_model.slim")
)

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

if (is.null(opt$slim_dir)){
  print_help(opt_parser)
  stop("Must supply path to SLiM simulation build (--slim_dir).n", call.=FALSE)
}

if (is.null(opt$slim_model)){
  print_help(opt_parser)
  stop("Must supply path to SLiM simulation script (--slim_model).n", call.=FALSE)
}

slim_build <- opt$slim_dir

seed <- as.numeric(opt$seed)
seed_high <- seed*10
seed_vector <- c(seed_high, (seed_high - seq(1,9,1)))
seed_len <- length(seed_vector)

slim_model <- opt$slim_model

calcFst <- function(p1, p2, N1, N2) {
  q1 <- 1 - p1
  q2 <- 1 - p2
  Ntotal <- N1 + N2
  p_bar <- ((p1*N1) + (p2*N2)) / (Ntotal)
  q_bar <- ((q1*N1) + (q2*N2)) / (Ntotal)
  Hexp1 <- 2 * p1 * q1
  Hexp2 <- 2 * p2 * q2
  Hs <- ((Hexp1*N1) + (Hexp2*N2))/(Ntotal) 
  Ht <- 2 * p_bar * q_bar
  Fst <- (Ht-Hs) / Ht
  return(Fst)
}

p1 <- as.numeric(opt$freq1)
p2 <- as.numeric(opt$freq2)
N1 <- 2
N2 <- 2

Fst <- calcFst(p1, p2, N1, N2)

model_name <- paste0(opt$out, "wholeautosome_12gen_m-0.5_Fst-", Fst)
mapply(seed=seed_vector, FUN = runSLiM, freq1=p1, freq2=p2, model_name=model_name, slim_model=slim_model)
