CXX=g++-5
CXXFLAGS=-std=c++14 -g -ggdb -Wall -Wextra -O3  -Wodr -flto


prog:prog.o tests/results
	$(CXX) -o prog prog.o $(LDFLAGS)	

clean:
	rm -f tests/*.result tests/*.test tests/*.result_ prog *.o


#This is a list of the tests
TESTS=inverse
TEST_RESULT=$(TESTS:%=tests/%.result_)


# Don't delete the intermediate files, since these can take a
# long time to regenerate
.PRECIOUS: tests/%.result tests/%.test


#We don't want this file hanging around on failure since we 
#want the build depend on it.
.DELETE_ON_ERROR: tests/results 

tests/results:$(TEST_RESULT)
	cat $(TEST_RESULT) > tests/results
	@echo -------------- Test Results ---------------
	@cat tests/results
	@echo -------------------------------------------
	@ ! grep -qv OK tests/results 


#Build a test executable from a test program. On compile error,
#create an execuaable which decalres the error.
tests/%.test: tests/%.cc
	$(CXX) $(CXXFLAGS) $< -o $@ -I . $(LDFLAGS) ||\
	{ \
	  echo "echo 'Compile error!'" > $@ ; \
	  chmod +x $@; \
	}

#Run the program and either use it's output (it should just say OK)
#or a failure message
tests/%.result: tests/%.test
	$< > $@ || ( echo Failed!!! > $@ )

tests/%.result_: tests/%.result
	echo $*: `tail -1 $<` > $@

#Get the C style dependencies working. Note we need to massage the test dependencies
#to make the filenames correct
.deps:
	rm -f .deps .sourcefiles
	find . -name "*.cc" | xargs -IQQQ $(CXX) $(CXXFLAGS) -MM -MG QQQ | sed -e'/test/s!\(.*\)\.o:!tests/\1.test:!'  > .deps

include .deps
