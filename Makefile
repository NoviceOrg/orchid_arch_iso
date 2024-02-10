CC = gcc
CXX = g++
CFLAGS = -std=c99
CXXFLAGS = -std=c++11
TARGETS = binary

SUBPROJECTS = bridged libbridge testcpp

.PHONY: all clean $(SUBPROJECTS)

all: $(TARGETS)

# We won't do non-binary. That will cause it to not run unless we refer to it as they/them.
binary: $(wildcard *.c *.cpp)
	for subdir in $(SUBPROJECTS); do \
		$(CXX) $(CXXFLAGS) $$subdir/*.c* -o $$subdir/$$subdir -I$$subdir; \
	done

clean:
	rm -f $(TARGETS) $(wildcard *.o */*.o)
	for subdir in $(SUBPROJECTS); do \
		$(MAKE) -C $$subdir clean; \
	done
