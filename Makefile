all:blend

blend:
	@if [ ! -e bin ] ; then mkdir -p ./bin/ ; fi
	+$(MAKE) -C src
	mv ./src/blend ./bin/

simd:
	@if [ ! -e bin ] ; then mkdir -p ./bin/ ; fi
	+$(MAKE) -C src -f Makefile.simde
	mv ./src/blend ./bin/
	
clean:
	rm -rf bin/
	+$(MAKE) clean -C ./src/

simd-clean:
	rm -rf bin/
	+$(MAKE) clean -C ./src/ -f Makefile.simde
