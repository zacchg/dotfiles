help:
	@echo "tree"
	@echo "overwrite-dotfiles-here"

tree:
	@echo "tree"
	@git ls-tree main -r --name-only | tree -a -F --fromfile .

overwrite-dotfiles-here:
	@echo "overwrite-dotfiles-here"
	@for f in $$(grep '^!\.' .gitignore | sed 's/!//g') ; do [ "$$f" = ".gitignore" ] && continue ; cp -v -a ~/"$$f" ./"$$f" ; done

.PHONY:
