
# strip envrc values

cat dev/perf-vm.envrc | sed -E 's/=.*/=/'