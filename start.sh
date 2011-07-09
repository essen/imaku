#!/bin/sh
erl -sname imaku -pa ebin -pa deps/*/ebin \
	-boot start_sasl -s imaku_app
