docker run -it --name uni-dev \
  --cap-add=NET_ADMIN \
  --device /dev/net/tun \
  -v "$HOME/MyProjects":/home/hamis/repos  \
  uni-dev
