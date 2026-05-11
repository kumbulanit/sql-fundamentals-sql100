# Tools Installation Guide — SQL100
### Assmang Pty Ltd SQL Fundamentals Training

---

## 🖥️ Recommended Operating System

> **✅ RECOMMENDED: Windows 10/11 (64-bit)**
>
> **Reason:** The majority of enterprise environments at Assmang run Windows. DBeaver and MySQL tools are most widely tested, documented, and supported on Windows. The majority of participants will already be on Windows laptops issued by IT.
>
> macOS and Linux are fully supported as alternatives.

---

## Tool 1: MySQL 8.x (Training Database Server)

### Purpose
MySQL is the relational database management system (RDBMS) used for all labs. It stores the Assmang training database and processes all SQL queries.

### Recommended Version
**MySQL 8.0.36+** (LTS, stable, widely supported)

---

### 🪟 Install on Windows

1. Go to: https://dev.mysql.com/downloads/installer/
2. Download **MySQL Installer (Windows)** — choose the "Full" installer (~450 MB)
3. Run the installer, choose **"Developer Default"** setup type
4. Accept defaults for most settings
5. When prompted for root password, set: `Assmang@2024` (or note your own)
6. Let installer configure MySQL as a Windows Service (starts automatically)
7. Finish installation

**Validate:**
```cmd
mysql -u root -p
-- Enter password when prompted
-- You should see: mysql>
SELECT VERSION();
-- Expected output: 8.0.36 (or higher)
EXIT;
```

---

### 🍎 Install on macOS

```bash
# Option 1: Homebrew (recommended)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install mysql@8.0
brew services start mysql@8.0

# Set path if needed
echo 'export PATH="/usr/local/opt/mysql@8.0/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Secure the installation
mysql_secure_installation
```

**Validate:**
```bash
mysql -u root -p
SELECT VERSION();
EXIT;
```

---

### 🐧 Install on Linux (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install mysql-server -y
sudo systemctl start mysql
sudo systemctl enable mysql
sudo mysql_secure_installation

# Verify
mysql --version
```

---

## Tool 2: DBeaver Community Edition (SQL Client / GUI)

### Purpose
DBeaver is a free, universal database client with a graphical interface. Participants use it to connect to MySQL, write queries, view table structures, and visualise results — without needing a command line.

### Recommended Version
**DBeaver 24.x** (Community Edition — free, no registration required)

---

### 🪟 Install on Windows

1. Go to: https://dbeaver.io/download/
2. Download **Windows Installer (64-bit)** — `dbeaver-ce-XX.X.X-x86_64-setup.exe`
3. Run installer, accept all defaults
4. Launch DBeaver from Start Menu

**Connect to MySQL:**
1. Click **"New Database Connection"** (plug icon or `File > New > Database Connection`)
2. Select **MySQL** → click **Next**
3. Fill in:
   - Host: `localhost`
   - Port: `3306`
   - Database: `assmang_training`
   - Username: `root`
   - Password: `Assmang@2024` (or your root password)
4. Click **"Test Connection"** — if prompted to download MySQL driver, click **Yes**
5. Click **Finish**

---

### 🍎 Install on macOS

1. Go to: https://dbeaver.io/download/
2. Download **macOS DMG** (Intel or Apple Silicon as appropriate)
3. Open DMG, drag DBeaver to Applications folder
4. Launch from Applications
5. Connect as described above (Windows instructions apply equally)

---

### 🐧 Install on Linux (Ubuntu/Debian)

```bash
# Option 1: Snap (easiest)
sudo snap install dbeaver-ce

# Option 2: .deb package
wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
sudo dpkg -i dbeaver-ce_latest_amd64.deb
```

---

## Tool 3: Git (Optional — for cloning course materials)

### Purpose
Git allows participants to download and version-control the course materials.

### Recommended Version
**Git 2.44+**

### Install

| OS | Command |
|----|---------|
| Windows | Download from https://git-scm.com/download/win — use all defaults |
| macOS | `brew install git` or install Xcode Command Line Tools: `xcode-select --install` |
| Linux | `sudo apt install git -y` |

**Validate:**
```bash
git --version
# Expected: git version 2.44.x
```

---

## Quick Pre-Training Checklist

Run these commands before the first session to confirm everything is working:

```sql
-- 1. Connect to MySQL in DBeaver or terminal
-- 2. Run the setup script: datasets/v1_assmang_setup.sql
-- 3. Verify:
SHOW DATABASES;
USE assmang_training;
SHOW TABLES;
SELECT COUNT(*) FROM employees;
-- Expected: 30 (rows) — confirms dataset loaded correctly
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Cannot connect: "Access denied" | Check username/password. Try `mysql -u root -p` in terminal first |
| Cannot connect: "Connection refused" | MySQL service not running. `sudo systemctl start mysql` or start from Windows Services |
| DBeaver "driver not found" | Click "Download" when DBeaver prompts for MySQL driver |
| Port 3306 in use | Another MySQL instance running. Check services |
| macOS "cannot open" DBeaver | Go to System Preferences → Security → "Open Anyway" |

---

*All tools are free and open-source. No licences required for this training.*

