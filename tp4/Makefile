BADGES_TARGET = niv1__abr_est_present niv3__abr_est_present_tail_call niv2__abr_vers_tab niv3__tri_nain niv3__tri_nain_opt niv3__tri_nain_superopt
BINS = comparer_nains


COMMON := ../common
include $(COMMON)/rules.mk
CFLAGS += -O3


abr_est_present: abr_est_present.o fct_abr_est_present.o

abr_est_present_tail_call: abr_est_present_tail_call.o fct_abr_est_present_tail_call.o

abr_vers_tab: abr_vers_tab.o fct_abr_vers_tab.o

tri_nain: tri_nain.o fct_tri_nain.o

tri_nain_opt: tri_nain_opt.o fct_tri_nain_opt.o

tri_nain_superopt: tri_nain_superopt.o fct_tri_nain_superopt.o

comparer_nains: comparer_nains.o fct_tri_nain.o fct_tri_nain_opt.o fct_tri_nain_superopt.o
