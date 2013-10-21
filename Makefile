all: basic

OBJS = parser.o  \
       token.o  \
       sym.o     

CPPFLAGS = -Wall -g -std=c++0x

clean:
	$(RM) -rf parser.cpp parser.hpp basic token.cpp $(OBJS)

parser.cpp: parser.y
	bison -d -o $@ $^
	
parser.hpp: parser.cpp

token.cpp: token.l parser.hpp
	flex -o $@ $^

%.o: %.cpp
	g++ -c $(CPPFLAGS) -o $@ $<


basic: $(OBJS)
	g++ -o $@ $(OBJS) $(LIBS) $(LDFLAGS)


