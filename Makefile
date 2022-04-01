P="\\033[34m[+]\\033[0m"

help:
	@echo tree

tree:
	@echo "$(P) tree"
	@git ls-tree main -r --name-only | tree -a -F --fromfile . | sed 's#/$$#:#g'

.PHONY:
