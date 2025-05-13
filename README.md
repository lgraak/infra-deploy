# infra-deploy: Proxmox Cloud-Init Template Automation

This project automates the creation of **cloud-init–ready VM templates** on a Proxmox VE cluster using Ansible. The templates can then be used for rapid VM cloning.

---

## 📦 Features

- Automatically downloads official Ubuntu or Debian cloud images
- Creates Proxmox VMs with proper cloud-init configuration
- Imports disks and attaches them with best practices (virtio-scsi, serial console)
- Resizes disks, enables guest agent, and converts VM to template
- Uses Ansible + bash wrapper for an interactive experience
- Prepares everything for future integration with Ansible Semaphore

---

## 🧰 Requirements

- Proxmox VE (7.x or 8.x)
- A working API Token:
  - Must be configured as an environment variable: `PROXMOX_API_TOKEN=root@pam!ansible=...`
  - Must have permissions to create/manage VMs, import disks, etc.
- Ansible installed in a Python virtual environment (recommended)
- SSH access from control node to the Proxmox nodes
- Proxmox storage (e.g. `proxmox-vmstore`) must support VM disk images

---

## 🚀 Installation

### 1. Clone this repository

```bash
git clone https://github.com/your-org/infra-deploy.git
cd infra-deploy
```

### 2. Set up Python virtual environment for Ansible

```bash
python3 -m venv /opt/ansible-venv
source /opt/ansible-venv/bin/activate
pip install ansible
```

### 3. Export your API token (add this to your `~/.bashrc`)

```bash
export PROXMOX_API_TOKEN='root@pam!ansible=YOURTOKEN'
```

### 4. Make the wrapper script executable

```bash
chmod +x run-create-template.sh
```

---

## 🛠️ How to Use

### Step 1: Create a cloud-init VM template

```bash
./run-create-template.sh
```

You'll be prompted to select:
- Proxmox node
- Distro (Ubuntu or Debian)
- LTS version (e.g., 22.04)
- Template name (default is suggested)
- VM ID
- CPU/RAM/Disk
- VLAN tag (optional)
- Cloud-init login credentials

Once complete, a reusable VM **template** will be created and visible in the Proxmox GUI.

### Step 2: Clone from this template (coming next)

We will build a second playbook that clones the created templates into new VMs with:
- Custom hostname
- SSH keys
- Static IP or DHCP
- Post-clone provisioning

---

## 🧪 Example Use Case

Build templates:
- `ubuntu-22.04-template` with VMID 9100
- `ubuntu-24.04-template` with VMID 9200
- `debian-12-template` with VMID 9300

Later, you can clone from these via CLI or Ansible in seconds.

---

## 🔐 Security Notes

- All VMs use cloud-init for first-boot setup.
- Root passwords and users are passed securely via Proxmox config.
- SSH key injection will be done **at clone time**, not in the template.
- Default password is required for template creation, but may be disabled later via cloud-init config or hardening scripts.

---

## 🪪 License

This project is licensed under the [Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/).

You may use, remix, and share this code **for non-commercial purposes only**, with attribution.

---

## 🙋 Support

If you're working with Proxmox, Ansible, cloud-init, or Semaphore and need help extending this—reach out or open an issue.
