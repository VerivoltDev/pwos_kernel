# PW Kernel builder

## How to get
 - To clone only the PW kernel branch use this command:
```
git clone -b PW/v6.1.69-09.02.00.005-phy3 --single-branch git@github.com:VerivoltDev/pwos_kernel.git
```

 -  To setup this branch as upstream:
 ```
 git branch --set-upstream-to=origin/PW/v6.1.69-09.02.00.005-phy3 PW/v6.1.69-09.02.00.005-phy3
```

## How to build

### Quick start

0. If you want a better experience, please see first the [hacks](#hacks) section
1. Generate enviromental vars (`.env` file): `./VV/scripts/genenv.sh`
2. Build the container: `docker compose build`
3. Build the kernel: `docker compose up`

Note: See the messages in the console to know where the build files are deployed

### Interative mode

- For interactive mode (console) you can run: `docker compose run pw-kernel-bash`
- If you want to clean the enviroment, you can run: `docker compose run pw-kernel-clean`

On interactive mode you can run this scripts to run some standalone process:

  - Setup environment: `source ~/SDK_PHYTEC/environment-setup-aarch64-phytec-linux`
  - Init Laird backports: `./VV/scripts/init_laird_backports.bash`
  - Build Only the kernel: `./VV/scripts/build_kenel.bash`
  - Build Only the Laird backports: `./VV/scripts/build_laird_backports.bash`

Additionally these info can be useful:

  - Path to powerwatch dts: `arch/arm64/boot/dts/ti/k3-am642-powerwatch-v0.4.dts`
  - Path to powerwatch config: `arch/arm64/configs/powerwatch.config`
  - Create .config: `make phytec_ti_defconfig phytec_ti_platform.config powerwatch.config`
  - Personalize config: `make menuconfig`
  - Save config: `make savedefconfig`
  - Verify kernel version: `make kernelversion`
  - Compile all: `make -j$(nproc)`
  - Compile only dtbs: `make dtbs`
  - Install Modules: `make INSTALL_MOD_PATH=OUT modules_install`
  - Path to compiled kernel: `arch/arm64/boot/Image`
  - Path to compiled dtb: `arch/arm64/boot/dts/ti/k3-am642-powerwatch-v0.4.dtb`

## HACKS

To speed up the Docker build, you can pre-download these files and save it on `./VV/DOWN` (you need to make this directory inside the repo):

 - Phytec SDK : 
 [main site](https://download.phytec.de/Software/Linux/BSP-Yocto-AM64x/BSP-Yocto-Ampliphy-AM64x-PD23.2.1/sdk/ampliphy/phytec-ampliphy-glibc-x86_64-phytec-headless-image-aarch64-toolchain-BSP-Yocto-Ampliphy-AM64x-PD23.2.1.sh) - 
 [backup site](https://github.com/VerivoltDev/pwos_kernel/releases/download/PW0310/phytec-ampliphy-glibc-x86_64-phytec-headless-image-aarch64-toolchain-BSP-Yocto-Ampliphy-AM64x-PD23.2.1.sh)

 - Laird Backports: 
 [main site](https://github.com/LairdCP/Sterling-LWB-and-LWB5-Release-Packages/releases/download/LRD-REL-12.29.0.22/summit-backports-12.29.0.22.tar.bz2) - 
 [backup site](https://github.com/VerivoltDev/pwos_kernel/releases/download/PW0310/summit-backports-12.29.0.22.tar.bz2)
 