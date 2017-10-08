all: georg

CXX = g++
LIBS = -lHTTPDFaust -lOSCFaust -lfaust -ljack -lecl
CFLAGS = -fpic $(shell llvm-config --ldflags --libs all) -fpermissive
FILES =

%.h: %.cc.lisp
	@echo "$< $@"
	@cm-cxx -E "(require :cm-ifs)" -E '(setf cm-ifs:*gen-interface* t)' $< -o $@

%.cc: %.cc.lisp
	@echo "CM $<"
	@cm-cxx -E "(require :cm-ifs)" -E '(setf cm-ifs:*gen-interface* nil)'  $< -o $@

georg: georg.h georg.cc ecl-helpers.h ecl-helpers.cc ecl-root.h ecl-root.cc faust.h faust.cc
	$(CXX) -lstdc++  $^ $(CFLAGS) $(LIBS) $(FILES) -o $@

clean:
	rm -f *.cc *.h georg
