# Makefile for device simulation layer
# mikew@lunarg.com

PROJ_NAME = device_simulation

RELEASE_DIR  = build
DEBUG_DIR    = dbuild
EXTERNAL_DIR = external

LIB_RELEASE_SOFILE = ${RELEASE_DIR}/layersvt/libVkLayer_${PROJ_NAME}.so
LIB_DEBUG_SOFILE   = ${DEBUG_DIR}/layersvt/libVkLayer_${PROJ_NAME}.so

.PHONY: all clean clobber nuke
.DELETE_ON_ERROR: ${LIB_RELEASE_SOFILE} ${LIB_DEBUG_SOFILE}

all: ${LIB_RELEASE_SOFILE} ${LIB_DEBUG_SOFILE}

${LIB_RELEASE_SOFILE}: ${RELEASE_DIR} layersvt/${PROJ_NAME}.cpp
	${MAKE} -C ${RELEASE_DIR}

${LIB_DEBUG_SOFILE}: ${DEBUG_DIR} layersvt/${PROJ_NAME}.cpp
	${MAKE} -C ${DEBUG_DIR}

${EXTERNAL_DIR}:
	./update_external_sources.sh

${RELEASE_DIR}: ${EXTERNAL_DIR}
	cmake -H. -B$@ -DCMAKE_BUILD_TYPE=Release

${DEBUG_DIR}: ${EXTERNAL_DIR}
	cmake -H. -B$@ -DCMAKE_BUILD_TYPE=Debug

test_release: ${LIB_RELEASE_SOFILE}
	${RELEASE_DIR}/tests/devsim_layer_test.sh

test_debug: ${LIB_DEBUG_SOFILE}
	${DEBUG_DIR}/tests/devsim_layer_test.sh

test: test_release test_debug

clean:
	rm -f ${LIB_RELEASE_SOFILE} \
		${LIB_DEBUG_SOFILE} \
		${RELEASE_DIR}/layersvt/CMakeFiles/VkLayer_${PROJ_NAME}.dir/*.o \
		${DEBUG_DIR}/layersvt/CMakeFiles/VkLayer_${PROJ_NAME}.dir/*.o

clobber: clean
	rm -rf ${RELEASE_DIR} ${DEBUG_DIR}

nuke: clobber
	rm -rf ${EXTERNAL_DIR}

# vim: set sw=4 ts=8 noet ic ai:
