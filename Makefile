BIN=./bin
DATA=./data
GEN=$(DATA)/gen
DEFS=$(DATA)/bkb.txt

all: $(GEN)/bkb_kanji_defs.txt \
	$(GEN)/bkb_word_pronun.txt \
	$(GEN)/bkb_word_meaning.txt \
	$(GEN)/bkb_word_all.txt

$(GEN)/bkb_kanji_defs.txt: $(DEFS)
	$(BIN)/bkb.pl $(DEFS) --iter=def --fields=Kanji,Defs > $@

$(GEN)/bkb_word_pronun.txt: $(DEFS)
	$(BIN)/bkb.pl $(DEFS) --iter=words --fields=Word,Pronun > $@

$(GEN)/bkb_word_meaning.txt: $(DEFS)
	$(BIN)/bkb.pl $(DEFS) --iter=words --fields=Word,Meaning > $@

$(GEN)/bkb_word_all.txt: $(DEFS)
	$(BIN)/bkb.pl $(DEFS) --iter=words --fields=Word,Meaning,Pronun,LearnWord > $@

clean:
	rm -rf $(GEN)/*
