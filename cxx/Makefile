all: kiss

CXX = g++
LIBS = -lfaust -ljack  -lecl
CFLAGS = -fpic $(shell llvm-config --ldflags --libs all)
FILES =

%.h: %.cc.lisp
	@echo "$< $@"
	@cm-cxx -E "(require :cm-ifs)" -E '(setf cm-ifs:*gen-interface* t)' $< -o $@

%.cc: %.cc.lisp
	@echo "CM $<"
	@cm-cxx -E "(require :cm-ifs)" -E '(setf cm-ifs:*gen-interface* nil)'  $< -o $@

kiss: kiss.h kiss.cc faust.h faust.cc ecl-helpers.h ecl-helpers.cc ecl-root.h ecl-root.cc
	@echo "gcc $(shell llvm-config --ldflags --libs all) $^"
	@$(CXX) $(LIBS) $(CFLAGS) $(FILES) $^ -o $@

clean:
	rm -f *.cc *.h kiss
