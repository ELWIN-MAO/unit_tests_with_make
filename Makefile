CXX=g++-5
CXXFLAGS=-std=c++14 -g -ggdb -Wall -Wextra -O3  -Wodr -flto


prog:prog.o tests/results
	$(CXX) -o prog prog.o $(LDFLAGS)	

clean:
	rm -f tests/*.result tests/*.test tests/*.result_ prog *.o


#Every .cc file in the tests directory is a test
TESTS=$(notdir $(basename $(wildcard tests/*.cc)))




#Get the intermediate file names from the list of tests.
TEST_RESULT=$(TESTS:%=tests/%.result)


# Don't delete the intermediate files, since these can take a
# long time to regenerate
.PRECIOUS: tests/%.result_ tests/%.test

#Add the rule "test" so make test works. It's not a real file, so
#mark it as phony
.PHONY: test
test:tests/results


#We don't want this file hanging around on failure since we 
#want the build depend on it. If we leave it behing then typing make
#twice in a row will suceed, since make will find the file and not try
#to rebuild it.
.DELETE_ON_ERROR: tests/results 

tests/results:$(TEST_RESULT)
	cat $(TEST_RESULT) > tests/results
	@echo -------------- Test Results ---------------
	@cat tests/results
	@echo -------------------------------------------
	@ ! grep -qv OK tests/results 


#Build a test executable from a test program. On compile error,
#create an executable which declares the error.
tests/%.test: tests/%.cc
	$(CXX) $(CXXFLAGS) $< -o $@ -I . $(LDFLAGS) ||\
	{ \
	  echo "echo 'Compile error!' ; return 126" > $@ ; \
	  chmod +x $@; \
	}

#Run the program and either use it's output (it should just say OK)
#or a failure message
tests/%.result_: tests/%.test
	$< > $@ ; \
	a=$$? ;\
	if [ $$a != 0 ]; \
	then \
	   if [ $$a -ge 128 and ] ; \
	   then \
	       echo Crash!! > $@ ; \
	   elif [ $$a -ne 126 ] ;\
	   then \
	       echo Failed > $@ ; \
	   fi;\
	else\
	    echo OK >> $@;\
	fi
	
tests/%.result: tests/%.result_
	echo $*: `tail -1 $<` > $@

#Get the C style dependencies working. Note we need to massage the test dependencies
#to make the filenames correct
.deps:
	rm -f .deps .sourcefiles
	find . -name "*.cc" | xargs -IQQQ $(CXX) $(CXXFLAGS) -MM -MG QQQ | sed -e'/test/s!\(.*\)\.o:!tests/\1.test:!'  > .deps

include .deps
