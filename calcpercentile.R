#!/usr/bin/env Rscript

suppressMessages(library(tidyverse))
suppressMessages(library(magrittr))

infile <- commandArgs(trailingOnly=TRUE)[1]

whole_genome_length <- 2883468901
bene_locus <- 100000000

#get seed number, Fst, p1 and p2
pattern <- "^.+/.+_Fst-(\\d.*\\d*)_freq1-(\\d.*\\d*)_freq2-(\\d.*\\d*)_seed-(\\d+)_"
pattern_match <- str_match(infile, pattern)
seed <- pattern_match[,5]
freq2 <- pattern_match[,4]
freq1 <- pattern_match[,3]
Fst <- pattern_match[,2]

#ANCESTRY PROPORTION STATS
ancestry_prop <- read.csv(infile, header = TRUE)
ancestry_prop$P1AncestryProportion <- 1 - ancestry_prop$P2AncestryProportion

bene_prop <- ancestry_prop[max(which(ancestry_prop$GenomicPosition<=bene_locus)),]$P1AncestryProportion

#mean global ancestry (weighted by interval size)
ancestry_prop$interval <- suppressWarnings(ancestry_prop$GenomicPosition[-1] - ancestry_prop$GenomicPosition)
ancestry_prop <- ancestry_prop[-c(nrow(ancestry_prop)),]
mean_globalancestry <- sum(ancestry_prop$P1AncestryProportion*ancestry_prop$interval/whole_genome_length)

bene_rank <- mean(c(ancestry_prop$P1AncestryProportion < bene_prop))

ancestry_sd <- sd(ancestry_prop$P1AncestryProportion)

cat(seed, Fst, freq1, freq2, bene_prop, bene_rank, mean_globalancestry, paste0(ancestry_sd, "\n"), sep="\t")

