# How to build

- Install SDK:
    - `wget https://download.phytec.de/Software/Linux/BSP-Yocto-AM64x/BSP-Yocto-Ampliphy-AM64x-PD23.2.1/sdk/ampliphy/phytec-ampliphy-glibc-x86_64-phytec-headless-image-aarch64-toolchain-BSP-Yocto-Ampliphy-AM64x-PD23.2.1.sh`
    - `chmod +x phytec-ampliphy-glibc-x86_64-phytec-headless-image-aarch64-toolchain-BSP-Yocto-Ampliphy-AM64x-PD23.2.1.sh`
    - `sh phytec-ampliphy-glibc-x86_64-phytec-headless-image-aarch64-toolchain-BSP-Yocto-Ampliphy-AM64x-PD23.2.1.sh -y -d ./SDK`


- Checkout to branch:
    - PD23.2.0: `PW/v6.1.33-phy3`
    - PD23.2.1: `PW/v6.1.69-09.02.00.005-phy3`
- Run the docker: `./run-docker.sh`
- Source SDK: `source ./SDK/environment-setup-aarch64-phytec-linux`
- Copy Config: `make phytec_ti_defconfig phytec_ti_platform.config`
- Personalize config: `make menuconfig`
- Save Config: `make savedefconfig`
- Verify kernel version: `make kernelversion`
- Compile: `make -j$(nproc)`
- Create OUT dirs: `mkdir -p ./OUT/boot/dtbs`
- Install dtbs (optional): `INSTALL_DTBS_PATH=OUT/boot/dtbs/ make dtbs_install`
- Install Modules: `make INSTALL_MOD_PATH=./OUT modules_install`
- Copy Kernel: `cp arch/arm64/boot/Image ./OUT/boot/`
- Copy dtb: `cp arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-rdk.dtb ./OUT/boot`
- Copy dtbo: `cp -v arch/arm64/boot/dts/ti/k3-am64-phyboard-electra-*.dtbo ./OUT/boot`

- `dtc -I dts -O dtb -o imx8mm-evk.dtb imx8mm-evk.dts`
- `make dtbs`
- `export INSTALL_PATH=PW160824`
- `make dtbs_install`
make distclean
make clean
