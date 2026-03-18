CXX      := g++
CXXFLAGS := -std=c++17 -O2 -Wall -Wextra

%.out: %.cpp
	$(CXX) $(CXXFLAGS) -Isrc $< -o $@

.PHONY: run clean

run: $(FILE:.cpp=.out)
	./$(FILE:.cpp=.out)

clean:
	find src -name "*.out" -delete
