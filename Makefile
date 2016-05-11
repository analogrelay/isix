.PHONY: all org.kernel.linux net.andrewnurse.isix.initrd clean

all: org.kernel.linux net.andrewnurse.isix.initrd

# Don't want to clean the kernel, it takes too long to build :)
clean:
	@rm -Rf build/packages/net.andrewnurse.isix.initrd

obliterate:
	@rm -Rf build

org.kernel.linux: build/kernel/4.0.5/vmlinux

net.andrewnurse.isix.initrd: build/packages/net.andrewnurse.isix.initrd/0.1.0/initramfs.igz

build/packages/net.andrewnurse.isix.initrd/0.1.0/initramfs.igz: build/packages/net.andrewnurse.isix.initrd/0.1.0/initramfs.cpio | build/packages/net.andrewnurse.isix.initrd/0.1.0
	@mkdir -p $(dir $@)
	@cat $< | gzip > $@

build/packages/net.andrewnurse.isix.initrd/0.1.0/initramfs.cpio: build/packages/net.andrewnurse.isix.initrd/0.1.0/init
	@mkdir -p $(dir $@)
	cd $(dir $<); echo $(notdir $<) | cpio -H newc -o > $(notdir $@)

build/packages/net.andrewnurse.isix.initrd/0.1.0/init: sources/net.andrewnurse.isix.initrd/0.1.0/init.c | build/packages/net.andrewnurse.isix.initrd/0.1.0
	@mkdir -p $(dir $@)
	gcc -static -o $@ $<

cache/linux-4.0.5.tar.xz:
	@mkdir -p $(dir $@)
	@echo "Downloading Linux Kernel Sources v4.0.5"
	@curl -o $@ https://kernel.org/pub/linux/kernel/v4.x/linux-4.0.5.tar.xz

build/kernel/4.0.5/vmlinux: sources/org.kernel.linux/4.0.5/linux-4.0.5/
	@mkdir -p $(dir $@)
	@echo "Compiling Linux Kernel"
	@cp -f sources/org.kernel.linux/4.0.5/kernel.config build/kernel/4.0.5/.config
	@cd build/kernel/4.0.5 && $(MAKE) -C ../../../sources/org.kernel.linux/4.0.5/linux-4.0.5

sources/org.kernel.linux/4.0.5/linux-4.0.5/: cache/linux-4.0.5.tar.xz
	@mkdir -p $(dir $@)
	@echo "Unpacking Linux Kernel Sources. This may take quite a while."
	@tar xJf $< -C sources/org.kernel.linux/4.0.5

# Produce the final layout of the image
# Layout:
#  /
#  /System - System Hive
#  /System/Boot - Boot data (symlinks to Kernel and Init bundles)
#  /System/Library/Bundles - Bundles! All the bundles!
