
OPA=opa
OPA_PLUGIN_BUILDER=opa-plugin-builder
EXE=main.exe

all : gmap.opp opa

gmap.opp: ../plugin/gmap.js
	$(OPA_PLUGIN_BUILDER) $^ -o $@

gmap.opx: gmap.opp ../plugin/gmap.opa
	$(OPA) $^ --no-server --autocompile

opa:	gmap.opx main.opa
	$(OPA) $^ -o $(EXE)

run:
	./main.exe

clean:
	rm -rf *.exe
	rm -rf _build _tracks
	rm -rf *.opp
	rm -rf *.opx

