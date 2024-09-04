# PW Kernel builder

To clone only the PW kernel branch use this command: 
`git clone -b PW/v6.1.69-09.02.00.005-phy3 --single-branch git@github.com:VerivoltDev/pwos_kernel.git`

## How to build

### Quick start
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

  - Path to powerwatch dts: `arch/arm64/boot/dts/ti/k3-am642-powerwatch-v0.3.dts`
  - Path to powerwatch config: `arch/arm64/configs/powerwatch.config`
  - Create .config: `make phytec_ti_defconfig phytec_ti_platform.config powerwatch.config`
  - Personalize config: `make menuconfig`
  - Save config: `make savedefconfig`
  - Verify kernel version: `make kernelversion`
  - Compile all: `make -j$(nproc)`
  - Compile only dtbs: `make dtbs`
  - Install Modules: `make INSTALL_MOD_PATH=OUT modules_install`
  - Path to compiled kernel: `arch/arm64/boot/Image`
  - Path to compiled dtb: `arch/arm64/boot/dts/ti/k3-am642-powerwatch-v0.3.dtb`

## HACKS

To speed up the Dockerbuild, you can pre [download the SDK](https://download.phytec.de/Software/Linux/BSP-Yocto-AM64x/BSP-Yocto-Ampliphy-AM64x-PD23.2.1/sdk/ampliphy/phytec-ampliphy-glibc-x86_64-phytec-headless-image-aarch64-toolchain-BSP-Yocto-Ampliphy-AM64x-PD23.2.1.sh) and save it on this dir inside the repo: `VV/DOWN/`