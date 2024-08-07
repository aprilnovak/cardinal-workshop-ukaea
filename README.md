
First clone the repository

```bash
git clone https://github.com/aprilnovak/cardinal-workshop-ukaea.git
```

Then run the docker image, you many need to change the ```$PWD/cardinal-workshop-ukaea``` directory used in the following command
```bash
docker run -p 8080:8080 --mount type=bind,source=$PWD/cardinal-workshop-ukaea,target=/workdir idaholab/cardinal:latest code-server-cardinal /workdir
```

Open the URL [http://0.0.0.0:8080/](http://0.0.0.0:8080/) in the browser

The webpage will prompt you for a password and this can be found printed to the terminal

Then use the open folder button and open the ```/workdir``` folder within the Jupyter instance running in the browser
