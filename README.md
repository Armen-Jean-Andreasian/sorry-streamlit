This is a hack to keep your Strealit apps never sleep.

All you need it to paste their URLs into yaml file

---

Simply paste your URL into project.yaml file (similary as I have provided my dummy projects in it)

---

To make this process automated:

1. Create a docker container

```Dockerfile
docker build -t selenium-chrome-container .
docker run -d selenium-chrome-container
```

2. and keep Docker running.

---

