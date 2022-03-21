# install go tools
# https://cs.opensource.google/go/x/tools
go install golang.org/x/tools/...@latest

# clean
go clean -i -testcache -modcache -x -r -cache