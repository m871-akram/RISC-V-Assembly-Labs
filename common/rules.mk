# Vérifie si la variable $COMMON est bien définie
$(if ${COMMON},,$(error COMMON doit être défini))

# Chemins et options pour les outils
RVDIR ?= /matieres/3MMCEP/riscv
AS = $(RVDIR)/bin/riscv32-unknown-elf-gcc
ASFLAGS = -g -c
CC = $(AS)
CFLAGS = -nostdinc -Wall -Wextra -g -std=c99 -mabi=ilp32 -mcmodel=medany -ffunction-sections -fdata-sections -fomit-frame-pointer -I$(RVDIR)/riscv32-unknown-elf/include -I$(RVDIR)/lib/gcc/riscv32-unknown-elf/13.2.0/include
LD = $(AS)
LDFLAGS = -L$(RVDIR)/lib -L$(RVDIR)/lib/cep_riscv_no_it -T cep.ld -nostartfiles -nostdlib -static -Wl,--nmagic -Wl,--gc-sections
# Ajoute le contenu de BADGES_TARGET à BINS, excepté un préfixe terminant par __. Exemple : niv1__foo_bar devient foo_bar
# /!\ Pas de __ autorisé dans la suite car on découpe à chaque __
BADGE_NAMES = $(foreach f, $(BADGES_TARGET),$(word 2, $(subst __, ,$f)))
BINS += $(BADGE_NAMES)

.PHONY: all clean
all: $(BINS)

%.o: %.s
	$(AS) $(ASFLAGS) -o $@ $<

# Extrait le contexte d'un fichier .s
%.ctxt: fct_%.s
	@sed -n "/DEBUT DU CONTEXTE/,/FIN DU CONTEXTE/p" $< | sed '1,1d; $$d' > $@

# Extrait le corps de la fonction d'un fichier .s
%.fun: fct_%.s
	sed -e "s/#.*$$//g" $< | cpp | sed -e "s/#.*$$//g" -e "/^$$/d" | sed -nE "/$*:/,/^[[:space:]]*([[:alnum:]]+:)?\<ret\>/p" > $@

# Vérification des étiquettes d'une fonction
%.stxetd: %.fun fct_%.s
	fonction=$*; awk -f $(COMMON)/ordre_etiquettes.awk -v fonction=$$fonction $< > $@; cat $@

STXETDOUTS = $(foreach f, $(BADGE_NAMES), $(addsuffix .stxetd, $f))
SORTIES    = $(foreach f, $(BADGE_NAMES), $(addsuffix .sortie, $f))
CONTEXTS  += $(foreach f, $(BADGE_NAMES), $(addsuffix .ctxt, $f))
FUNCTIONS  = $(foreach f, $(BADGE_NAMES), $(addsuffix .fun, $f))
OBJS       = $(foreach f, $(BINS), $(addsuffix .o, $f)) \
             $(foreach f, $(BINS), $(addprefix fct_, $(addsuffix .o, $f)))

clean:
	$(RM) $(BINS) $(OBJS) $(TMPOBJS) $(CONTEXTS) $(FUNCTIONS) $(STXETDOUTS) $(SORTIES)

