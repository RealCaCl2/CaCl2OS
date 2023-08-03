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