FLAGS = -I include -Wall -fPIC
LIBS = lib/TUN.o lib/CR.o -lliquid -luhd -lpthread -lm -lc -lconfig

all: TUN TUN_test CR CR_test CRTS_UE read_configs CRTS_controller post_process_logs

TUN: src/TUN.cpp
	g++ $(FLAGS) -c -o lib/TUN.o src/TUN.cpp

TUN_test: test/TUN.cpp
	g++ $(FLAGS) -o TUN test/TUN.cpp lib/TUN.o -lpthread

CR: include/CR.hpp src/CR.cpp
	# Execute program that reads CE's from master CE file and
	# modifies CR.cpp to map string names to these functions
	g++ $(FLAGS) -c -o lib/CR.o src/CR.cpp

CR_test: include/CR.hpp src/TUN.cpp src/CR.cpp test/CR_test.cpp
	g++ $(FLAGS) -o CR_test test/CR_test.cpp $(LIBS)

CRTS_UE : include/CR.hpp src/TUN.cpp src/CR.cpp src/CRTS_UE.cpp
	g++ $(FLAGS) -o CRTS_UE src/CRTS_UE.cpp src/read_configs.cpp $(LIBS)

CRTS_AP : src/CRTS_AP.cpp
	g++ $(FLAGS) -c -o CRTS_AP src/CRTS_AP.cpp lib/CR.o lib/CR.o

CRTS_interferer : src/CRTS_interferer.cpp
	g++ $(FLAGS) -c -o CRTS_interferer src/CRTS_interferer.cpp lib/CE.o lib/CR.o

read_configs: src/read_configs.cpp
	g++ $(FLAGS) -c -o lib/read_configs.o src/read_configs.cpp

CRTS_controller: include/node_parameters.hpp src/CRTS_controller.cpp src/read_configs.cpp
	g++ $(FLAGS) -o CRTS_controller src/CRTS_controller.cpp lib/read_configs.o -lconfig

post_process_logs: src/post_process_logs.cpp
	g++ $(FLAGS) -o post_process_logs src/post_process_logs.cpp $(LIBS)
