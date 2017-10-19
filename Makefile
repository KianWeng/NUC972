all: image/OS.bin

image/OS.bin: image/970uimage image/u-boot.bin
	cd image && ./generate_bin.sh && cd - > /dev/null 2>&1 && cp $@ .

image/970uimage:
	make -C linux-3.10.x nuc972_yytd_defconfig
	make -C linux-3.10.x uImage -j4

image/u-boot.bin:
	make -C uboot nuc970_yytd_config
	make -C uboot all
	cp uboot/u-boot.bin $@

.PHONY: clean distclean

clean:
	rm OS.bin
	rm -rf image/OS.bin
	rm -rf image/970uimage
	rm -rf image/970image
	rm -rf image/970image.zip
	rm -rf image/u-boot.bin
	make -C uboot clean
	make -C linux-3.10.x clean

distclean: clean
	make -C uboot distclean
	make -C linux-3.10.x distclean
