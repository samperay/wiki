**<h1>Troubleshooting</h1>**

- [kernel panic: not syncing attempting to kill init](#kernel-panic-not-syncing-attempting-to-kill-init)
- [linux booting drops into grub\>](#linux-booting-drops-into-grub)
- [system keeps on rebooting](#system-keeps-on-rebooting)
- [checking filesystems fsck.ext3: unable to resolve **LABEL=/5**  \[ FAILED \]](#checking-filesystems-fsckext3-unable-to-resolve-label5---failed-)
- [Verifying DMI pool data](#verifying-dmi-pool-data)
- [You lost your GRUB password, how would you recover ?](#you-lost-your-grub-password-how-would-you-recover-)
- [root unable to login](#root-unable-to-login)

## kernel panic: not syncing attempting to kill init

The issue is due to kernel image or the grub related, system wasn't able to locate the kernel or the label associated with it. 

Solution, attempt the linux machine into the sigle user mode, check the contents of the  **grub.conf** , which is tempravory, try modifying the file and bring up the system in runlevel 3. 

Once the machine is up, you can modify the grub.conf accordingly and boot the system.

## linux booting drops into grub>

grub wasn't able to find the second stage boot loader. try to load the second stage to boot the machine. 

```
grub> root(hd0,0)
grub> kernel /vmlinux<tab> ro root=LABEL=/1
grub> initrd /initrd<tab>
grub> boot
```

Once the machine boots, you would check where is the second stage boot loader and will fix it.

## system keeps on rebooting

it could be a hardware related or the login related. 

Solution: Try to boot the system into single user mode, and if you find the error as **no more process left in the runlevel**, which means system is not able to start the process and you would required to boot in the rescue level. 

First, check the runlevel in /etc/inittab file, if runlevel is not correct, fix it

secondly

```
Mount ISO or DVD
: linux rescue
<skip>

chroot /mnt/sysimage
cd etc
ls | grep inittab 
ls | grep /etc/grub/grub.conf
exit 
reboot

```

## checking filesystems fsck.ext3: unable to resolve **LABEL=/5**  [ FAILED ]

Your file system file is corrupted, it can't find the parition or label to mount the directories. 

Solution: provide your single user password and fix the **/etc/fstab**

```
cat /etc/fstab
<check for correct entries>
e2label /dev/sda3
mount -o remount,rw /etc/fstab
vim /etc/fstab
```

## Verifying DMI pool data

first stage boot loader is corrupted. 

Solution: 

```
chroot /mnt/sysimage
grub-install /dev/sda
ctrl-d
```

## You lost your GRUB password, how would you recover ?

Linux terminal, type
```grub-md5-crypt >>/boot/grub/grub.conf```
prefix it with **password --md5 $jshhx.....**

insert ISO image or DVD, at the boot prompt, type  **linux rescue** 
```
chroot /mnt/sysimage/
vim /etc/grub/grub.conf

Delete the line with any password entry, save and quit the file

exit
```

## root unable to login

  1) **password wrong**

  2) **bash not presented for root a/c**
    Symptom: when you type root login password, it will give you non-login shell. i.e password file corrupted. 

    Solution: Go to single user mode, edit /etc/password(remove the passsord entry), save & quit

  3) **/etc/securetty file corrupted**
    try logging into the nonroot user and see if it works. only if root not abel to login, then the issue is with /etc/securetty. 

    Solution: single usermode, verify settings in /etc/securetty

