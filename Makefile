TESTS=racine_behavorial_test racine_structural_test racine_combinatorial_test additionneur_soustracteur_test reg_decg_accu_test uc_test

DEPENDENCIES_racine_behavorial_test=additionneur_cascadable.vhd additionneur.vhd complement_a_deux.vhd additionneur_soustracteur.vhd bascule_d.vhd reg_decg_accu.vhd uc.vhd racine.vhd racine_behavorial_test.vhd
DEPENDENCIES_racine_structural_test=additionneur_cascadable.vhd additionneur.vhd complement_a_deux.vhd additionneur_soustracteur.vhd bascule_d.vhd reg_decg_accu.vhd uc.vhd racine.vhd racine_structural_test.vhd
DEPENDENCIES_racine_combinatorial_test=additionneur_cascadable.vhd additionneur.vhd complement_a_deux.vhd additionneur_soustracteur.vhd bascule_d.vhd reg_decg_accu.vhd uc.vhd racinecomb.vhd racine_combinatorial_test.vhd
DEPENDENCIES_additionneur_soustracteur_test=additionneur_cascadable.vhd additionneur.vhd complement_a_deux.vhd additionneur_soustracteur.vhd additionneur_soustracteur_test.vhd
DEPENDENCIES_reg_decg_accu_test=additionneur_cascadable.vhd additionneur.vhd bascule_d.vhd reg_decg_accu.vhd reg_decg_accu_test.vhd
DEPENDENCIES_uc_test=uc.vhd uc_test.vhd

GHDLFLAGS= --std=08 --workdir=work

all: $(TESTS)

%.compiled: %.vhd
	mkdir -p work
	ghdl -a $(GHDLFLAGS) --workdir=work $<
	touch $@

define test_template =
$(1): $$(addsuffix .compiled, $$(basename $$(DEPENDENCIES_$(1))))
	ghdl -e $(GHDLFLAGS) $(1)
	$$(foreach file,$$(DEPENDENCIES_$(1)),touch $$(basename $$(file));)
endef

$(foreach test,$(TESTS),$(eval $(call test_template,$(test))))

test: $(TESTS)
	@for test in $(TESTS); do \
		echo -ne "$$test : " && \
		ghdl -r $(GHDLFLAGS) $$test; \
		done

%.ghw: %.compiled
	ghdl -r $(GHDLFLAGS) $(basename $<) --wave=$@

%.vcd: %.compiled
	ghdl -r $(GHDLFLAGS) $(basename $<) --vcd=$@

vcd: $(addsuffix .vcd, $(TESTS)) 

ghw: $(addsuffix .ghw, $(TESTS))

clean:
	ghdl --clean $(GHDLFLAGS) 2>/dev/null
	rm -rf work
	rm -f $(TESTS)
	rm -f $(addsuffix .vcd, $(TESTS))
	rm -f $(addsuffix .ghw, $(TESTS))
	rm -f $(foreach test,$(TESTS),$(addsuffix .compiled, $(basename $(DEPENDENCIES_$(test)))))

