cat bypass_prefixes | grep -v "python" | python -c "import sys; print('\\'.join([line.strip() for line in sys.stdin]))"
