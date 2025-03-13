# Setup Nvidia Container Toolkit in WSL

Install WSL in powershell:

```powershell
wsl --install Ubuntu-24.04 --name nv-ctk --location C:\Dev\WSL\NVIDIA-Container-Toolkit --web-download
```

Setup Nvidia Container Toolkit in WSL:

```bash
mkdir ~/.setup && cd ~/.setup \
  && git clone https://github.com/xiaoyang9730/setup-nvidia-container-toolkit \
  && cd setup-nvidia-container-toolkit \
  && sudo sh setup-nvidia-container-toolkit.sh | sudo tee /var/log/setup-nvidia-container-toolkit.log
```
