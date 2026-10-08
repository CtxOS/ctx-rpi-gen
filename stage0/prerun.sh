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
	mkdir -p "${STAGE_WORK_DIR}"
	# debootstrap tests that it can create and use device nodes on the
	# target, which fails when the filesystem is mounted nodev (common
	# for container volumes and CI filesystems)
	mount -o remount,dev "$(findmnt -no TARGET -T "${STAGE_WORK_DIR}")" 2>/dev/null || true
	bootstrap ${RELEASE} "${ROOTFS_DIR}" http://raspbian.raspberrypi.com/raspbian/
fi
