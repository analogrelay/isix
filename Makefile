.PHONY: all org.kernel.linux net.andrewnurse.isix.initrd clean

all: org.kernel.linux net.andrewnurse.isix.initrd

# Don't want to clean the kernel, it takes too long to build :)
clean:
	@rm -Rf build/net.andrewnurse.isix.initrd

obliterate:
	@rm -Rf build

run: build/org.kernel.linux/4.0.5/arch/x86_64/boot/bzImage build/net.andrewnurse.isix.initrd/0.1.0/initramfs.igz
	@qemu-system-x86_64 -kernel build/org.kernel.linux/4.0.5/arch/x86_64/boot/bzImage -initrd build/net.andrewnurse.isix.initrd/0.1.0/initramfs.igz -serial stdio -vga std -append "console=ttyAMA0 console=ttyS0"

org.kernel.linux: build/org.kernel.linux/4.0.5/arch/x86_64/boot/bzImage

net.andrewnurse.isix.initrd: build/net.andrewnurse.isix.initrd/0.1.0/initramfs.igz

build/net.andrewnurse.isix.initrd/0.1.0/initramfs.igz: build/net.andrewnurse.isix.initrd/0.1.0/initramfs.cpio | build/net.andrewnurse.isix.initrd/0.1.0
	@cat $< | gzip > $@

build/net.andrewnurse.isix.initrd/0.1.0/initramfs.cpio: build/net.andrewnurse.isix.initrd/0.1.0/init
	cd $(dir $<); echo $(notdir $<) | cpio -H newc -o > $(notdir $@)

build/net.andrewnurse.isix.initrd/0.1.0/init: sources/net.andrewnurse.isix.initrd/0.1.0/init.c | build/net.andrewnurse.isix.initrd/0.1.0
	gcc -static -o $@ $<

build/net.andrewnurse.isix.initrd/0.1.0/: build/net.andrewnurse.isix.initrd
	@mkdir $@

build/net.andrewnurse.isix.initrd/: build
	@mkdir $@

cache/:
	@mkdir $@

cache/linux-4.0.5.tar.xz: cache
	@echo "Downloading Linux Kernel Sources v4.0.5"
	@curl -o $@ https://kernel.org/pub/linux/kernel/v4.x/linux-4.0.5.tar.xz

build/org.kernel.linux/4.0.5/vmlinux: build/org.kernel.linux/4.0.5
	@cp -f sources/org.kernel.linux/4.0.5/kernel.config build/org.kernel.linux/4.0.5/.config
	@$(MAKE) -C sources/org.kernel.linux/4.0.5/linux-4.0.5 O=build/org.kernel.linux/4.0.5

build/org.kernel.linux/4.0.5/: build/org.kernel.linux
	@mkdir $@

build/org.kernel.linux/: build
	@mkdir $@

build/:
	@mkdir $@

sources/org.kernel.linux/4.0.5/linux-4.0.5/: cache/linux-4.0.5.tar.xz | sources/org.kernel.linux/4.0.5
	@echo "Unpacking Linux Kernel Sources"
	@tar xf $< -C sources/org.kernel.linux/4.0.5

sources/org.kernel.linux/4.0.5/: | sources/org.kernel.linux
	@mkdir $@

sources/org.kernel.linux/: | sources/
	@mkdir $@

sources/:
	@mkdir $@
