all: image/OS.bin

image/OS.bin: uImage uboot
	cd image && ./generate_bin.sh && cd - > /dev/null 2>&1 && cp $@ .

uImage:
	make -C linux-3.10.x nuc972_yytd_defconfig
	make -C linux-3.10.x uImage -j4

uboot:
	make -C uboot nuc970_yytd_config
	make -C uboot all
	cp uboot/u-boot.bin image/uboot.bin

.PHONY: uboot uImage uboot_clean uImage_clean clean distclean

uboot_clean:
	rm -rf image/uboot.bin
	make -C uboot clean

uImage_clean:
	rm -rf image/970uimage
	rm -rf image/970image
	rm -rf image/970image.zip
	make -C linux-3.10.x clean

clean: uboot_clean uImage_clean
	rm OS.bin
	rm -rf image/OS.bin

distclean: clean
	make -C uboot distclean
	make -C linux-3.10.x distclean
