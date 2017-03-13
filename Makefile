SOURCE = bootloader.asm
BINARY = bootloader.bin
FLOPPY = os.flp

default: compile floppy clean

floppy:
	dd conv=notrunc bs=512 count=1 if=${BINARY} of=${FLOPPY}

compile:
	nasm -f bin -o ${BINARY} ${SOURCE}

clean:
	${RM} ${BINARY}

cleanAll:
	${RM} ${BINARY}
	${RM} ${FLOPPY}


.PHONY: clean compile floppy default
