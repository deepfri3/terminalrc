#!/usr/bin/env bash
set -euo pipefail

CFG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
PARSER_DIR="$CFG/parser"
QUERY_DIR="$CFG/queries"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$PARSER_DIR" "$QUERY_DIR"

# lang | git repo | subdir (for monorepos; "." if root)
GRAMMARS=(
  "cpp|https://github.com/tree-sitter/tree-sitter-cpp|."
  "c|https://github.com/tree-sitter/tree-sitter-c|."
  "python|https://github.com/tree-sitter/tree-sitter-python|."
  "bash|https://github.com/tree-sitter/tree-sitter-bash|."
  "json|https://github.com/tree-sitter/tree-sitter-json|."
  "yaml|https://github.com/tree-sitter-grammars/tree-sitter-yaml|."
  "go|https://github.com/tree-sitter/tree-sitter-go|."
  "rust|https://github.com/tree-sitter/tree-sitter-rust|."
)

get_query_files() {
  # Vendor Neovim query files from nvim-treesitter (master branch = classic query layout)
  local qrepo="/tmp/nvim-treesitter-u261602"
  local lang="$1"
  if [ ! -d "$qrepo/queries/$lang" ]; then
    git clone --depth 1 --branch master \
      https://github.com/nvim-treesitter/nvim-treesitter "$qrepo" >/dev/null 2>&1
  fi
  for lang in cpp python bash json yaml go rust; do
	if [ -d "$qrepo/queries/$lang" ]; then
	  mkdir -p "$QUERY_DIR/$lang"
	  cp "$qrepo/queries/$lang"/*.scm "$QUERY_DIR/$lang/"
	fi
  done
}

build_one() {
  local lang="$1" repo="$2" sub="$3"
  local dir="$TMP/$lang"
  echo "==> $lang"
  git clone --depth 1 "$repo" "$dir" >/dev/null 2>&1
  local src="$dir/$sub/src"

  # Collect sources: parser.c is always present; scanner may be .c or .cc
  local srcs=("$src/parser.c")
  local linker="cc"
  [ -f "$src/scanner.c" ]  && srcs+=("$src/scanner.c")
  if [ -f "$src/scanner.cc" ]; then srcs+=("$src/scanner.cc"); linker="c++"; fi

  $linker -o "$PARSER_DIR/$lang.so" -shared -Os -fPIC -I"$src" "${srcs[@]}"

  # Copy query files if the grammar ships them (nvim/queries or queries/)
  #for qsrc in "$dir/$sub/queries/nvim" "$dir/$sub/queries"; do
  #  if [ -d "$qsrc" ]; then
  #    mkdir -p "$QUERY_DIR/$lang"
  #    cp "$qsrc"/*.scm "$QUERY_DIR/$lang/" 2>/dev/null || true
  #    break
  #  fi
  #done

  get_query_files $lang
}

for g in "${GRAMMARS[@]}"; do
  IFS='|' read -r lang repo sub <<< "$g"
  build_one "$lang" "$repo" "$sub" || echo "!! failed: $lang (skipped)"
done

echo "Done. Parsers in $PARSER_DIR"

