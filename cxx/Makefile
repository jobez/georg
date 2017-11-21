all: georg

CXX = g++
LIBS = $(shell ecl-config --ldflags) -lHTTPDFaust -lOSCFaust -lfaust -ljack -lecl # -lshen
CFLAGS = $(shell ecl-config --cflags) $(shell pkg-config --cflags --libs rtmidi) $(shell llvm-config --ldflags --libs all) -L../ecl -fpermissive
FILES =

%.h: %.cc.lisp
	@echo "$< $@"
	@cm-cxx -E "(require :cm-ifs)" -E '(setf cm-ifs:*gen-interface* t)' $< -o $@

%.cc: %.cc.lisp
	@echo "CM $<"
	@cm-cxx -E "(require :cm-ifs)" -E '(setf cm-ifs:*gen-interface* nil)'  $< -o $@

georg: georg.h georg.cc ecl-helpers.h ecl-helpers.cc ecl-root.h ecl-root.cc faust.h faust.cc audio.h audio.cc
	$(CXX)  $^ $(CFLAGS) $(LIBS) $(FILES) -o $@

clean:
	rm -f *.cc *.h georg
