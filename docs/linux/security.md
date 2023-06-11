**<h1>Security</h1>**

- [Linux security checklist](#linux-security-checklist)

## Linux security checklist

- Keep the system Updated with Latest Security Patches
- Keep Yourself updated with latest vulnerabilities through mailing lists, forums etc.
- Disable and stop unwanted services on the server
- Use SUDO to limit ROOT Access
- SSH security settings
- Check the integrity of critical files using checksum
- Tunnel all of your X-Window Sessions through SSH
- Use SeLinux If required.
- Only create required no of users
- Maintain a good firewall policy
- Configure SSL/TLS if you are using FTP
- check file permissions accross filesystems.
- Use tools like adeos for potential file state
- Ensure sticky bit on /tmp Directory
- check and lock users with blank passwords.
- Bootloader and BIOS security
- Give special attention to portmap related services
- Deploy your NFS shares with Kerberos Authentication.
- Enable remote Logging
- Disable root Logins by editing /etc/securetty
- Keep A good Pasword Policy