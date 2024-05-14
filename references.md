kill port
```
kill -9 $(lsof -t0)
kill -9 $(lsof -t -i:300011)sd