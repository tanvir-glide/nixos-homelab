{
  config,
  pkgs,
  lib,
  ...
}: {
  boot.kernel.sysctl = {
    "dev.tty.ldisc_autoload" = 0;
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;
    "fs.suid_dumpable" = 0;
    "kernel.kptr_restrict" = 2;
    "kernel.modules_disabled" = 0;
    "kernel.sysrq" = 0;
    "kernel.unprivileged_bpf_disabled" = 1;
    "net.core.bpf_jit_harden" = 2;
    "net.ipv4.conf.all.forwarding" = 0;
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.default.log_martians" = 1;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
  };

  # ----------------------------------------------- Audit daemon ------------------------------------------

  security = {
    protectKernelImage = true;
    forcePageTableIsolation = true;
    auditd = {
      enable = true;

      settings = {
        max_log_file = 20;
        max_log_file_action = "ROTATE";
        num_logs = 3;
      };
    };

    audit = {
      enable = true;

      rules = [
        "-w /etc/sudoers -p wa -k sudoers"
        "-w /etc/sudoers.d/ -p wa -k sudoers"
        "-w /etc/passwd -p wa -k identity"
        "-w /etc/group -p wa -k identity"
        "-w /etc/shadow -p wa -k identity"
        "-w /etc/ssh/sshd_config -p wa -k sshd"
        "-a always,exit -F arch=b64 -S execve -k exec"
      ];
    };
  };
}
