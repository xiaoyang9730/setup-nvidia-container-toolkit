# --------------------------------------
# Refs:
#   - https://docs.nvidia.com/datacenter/cloud-native/container-toolkit
#   - https://docs.docker.com/engine/install/ubuntu
# --------------------------------------

# Update packages
apt-get update \
  && apt-get upgrade -y

# --------------------------------------
# Install Docker
# --------------------------------------

# Uninstall all conflicting packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do \
  apt-get remove $pkg; \
done

# Set up Docker's apt repository
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install the Docker packages
apt-get update \
  && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# --------------------------------------
# Install NVIDIA Container Toolkit
# --------------------------------------

# Configure the production repository
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Optionally, configure the repository to use experimental packages
# sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Install the NVIDIA Container Toolkit packages
apt-get update \
  && apt-get install -y nvidia-container-toolkit

# --------------------------------------
# Configure Docker
# --------------------------------------

# Configure the container runtime by using the `nvidia-ctk` command
nvidia-ctk runtime configure --runtime=docker \
  && systemctl restart docker

# Run a sample CUDA container
docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
