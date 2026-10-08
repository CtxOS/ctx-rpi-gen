#!/bin/bash -e

if [ "$RELEASE" != "trixie" ]; then
	echo "WARNING: RELEASE does not match the intended option for this branch."
	echo "         Please check the relevant README.md section."
fi

if [ "${USE_QCOW2}" != "1" ] && [ -d "${ROOTFS_DIR}" ] && [ ! -f "${STAGE_WORK_DIR}/bootstrap-complete" ]; then
	echo "Removing incomplete rootfs ${ROOTFS_DIR} left by a previous run"
	unmount "${ROOTFS_DIR}"
	rm -rf "${ROOTFS_DIR}"
fi

if [ ! -d "${ROOTFS_DIR}" ]; then
	bootstrap ${RELEASE} "${ROOTFS_DIR}" http://raspbian.raspberrypi.com/raspbian/
fi
