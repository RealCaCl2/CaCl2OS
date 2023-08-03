GPPPARAMS = -m32 -fno-use-cxa-atexit -fno-exceptions -fleading-underscore -fno-builtin -nostdlib -fno-rtti -fno-pic -fno-pie
ASPARAMS = --32
LDPARAMS = -melf_i386 -no-pie

objects = loader.o kernel.o

%.o: %.cpp
	g++ ${GPPPARAMS} -o $@ -c $<

%.o: %.s
	as ${ASPARAMS} -o $@ $<

mykernel.bin: linker.ld ${objects}
	ld ${LDPARAMS} -T $< -o $@ ${objects} -no-pie

install: mykernel.bin
	sudo cp $< /boot/mykernel.bin
system.iso: mykernel.bin
	mkdir iso
	mkdir iso/boot
	mkdir iso/boot/grub
	cp $< iso/boot/
	echo 'set timeout=0' > iso/boot/grub/grub.cfg
	echo 'set default=0' >> iso/boot/grub/grub.cfg
	echo '' >> iso/boot/grub/grub.cfg
	echo 'menuentry "CaCl2 OS"{' >> iso/boot/grub/grub.cfg
	echo '	multiboot /boot/mykernel.bin' >> iso/boot/grub/grub.cfg
	echo '	boot' >> iso/boot/grub/grub.cfg
	echo '}' >> iso/boot/grub/grub.cfg
	grub-mkrescue --output $@ iso
	rm -rf iso