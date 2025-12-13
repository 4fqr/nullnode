// Kali Linux Terminal Emulator (Client-Side)
// Simulates a Kali Linux environment in the browser

class KaliTerminal {
    constructor(terminalElement) {
        this.term = new Terminal({
            cursorBlink: true,
            fontSize: 14,
            fontFamily: '"Fira Code", "Courier New", monospace',
            theme: {
                background: '#000000',
                foreground: '#00ff88',
                cursor: '#00ff88',
                black: '#000000',
                red: '#ff5555',
                green: '#50fa7b',
                yellow: '#f1fa8c',
                blue: '#bd93f9',
                magenta: '#ff79c6',
                cyan: '#8be9fd',
                white: '#f8f8f2'
            }
        });

        this.fitAddon = new FitAddon.FitAddon();
        this.term.loadAddon(this.fitAddon);
        this.term.open(terminalElement);
        this.fitAddon.fit();

        this.currentLine = '';
        this.commandHistory = [];
        this.historyIndex = 0;
        this.currentDir = '/home/kali';
        this.username = 'kali';
        this.hostname = 'nullsector';

        this.fileSystem = {
            '/': {
                type: 'dir',
                contents: ['home', 'etc', 'usr', 'var', 'tmp', 'opt']
            },
            '/home': {
                type: 'dir',
                contents: ['kali']
            },
            '/home/kali': {
                type: 'dir',
                contents: ['Desktop', 'Documents', 'Downloads', 'tools', 'scripts', 'notes.txt', 'exploit.py', 'targets.txt']
            },
            '/home/kali/notes.txt': {
                type: 'file',
                content: 'Welcome to NullSector Kali Lab!\n\nRemember:\n- Always practice ethical hacking\n- Get written permission before testing\n- Use these skills for good\n\nHappy hacking!'
            },
            '/home/kali/exploit.py': {
                type: 'file',
                content: '#!/usr/bin/env python3\n# Sample exploit template\nimport socket\nimport sys\n\nprint("[*] NullSector - Ethical Hacking Lab")\nprint("[*] This is a simulated environment")\nprint("[!] Always get permission before testing!")\n'
            },
            '/home/kali/targets.txt': {
                type: 'file',
                content: '# Practice targets (simulated)\n10.10.10.1\n10.10.10.2\nexample.com\ntestsite.local\n'
            },
            '/home/kali/tools': {
                type: 'dir',
                contents: ['nmap.sh', 'scan.sh', 'README.md', 'wordlist.txt']
            },
            '/home/kali/tools/README.md': {
                type: 'file',
                content: '# NullSector Tools\n\nAvailable scripts:\n- nmap.sh: Network scanner\n- scan.sh: Port scanner\n- wordlist.txt: Common passwords\n'
            },
            '/home/kali/tools/wordlist.txt': {
                type: 'file',
                content: 'admin\npassword\n123456\nroot\nkali\nubuntu\n'
            },
            '/home/kali/scripts': {
                type: 'dir',
                contents: ['web_enum.sh', 'dns_lookup.py']
            },
            '/home/kali/Desktop': {
                type: 'dir',
                contents: ['projects', 'reports']
            },
            '/home/kali/Documents': {
                type: 'dir',
                contents: ['pentesting-notes.md']
            },
            '/home/kali/Downloads': {
                type: 'dir',
                contents: []
            },
            '/etc': {
                type: 'dir',
                contents: ['passwd', 'shadow', 'hosts', 'hostname']
            },
            '/etc/passwd': {
                type: 'file',
                content: 'root:x:0:0:root:/root:/bin/bash\nkali:x:1000:1000:Kali:/home/kali:/bin/bash\n'
            },
            '/etc/hosts': {
                type: 'file',
                content: '127.0.0.1\tlocalhost\n127.0.1.1\tnullsector\n::1\t\tlocalhost ip6-localhost ip6-loopback\n'
            }
        };

        this.commands = {
            help: () => this.showHelp(),
            clear: () => this.term.clear(),
            ls: (args) => this.listFiles(args),
            pwd: () => this.printWorkingDir(),
            cd: (args) => this.changeDirectory(args),
            cat: (args) => this.catFile(args),
            echo: (args) => args.join(' '),
            whoami: () => this.username,
            hostname: () => this.hostname,
            date: () => new Date().toString(),
            uname: (args) => 'Linux nullsector 5.10.0-kali7-amd64 #1 SMP Debian 5.10.40-1kali1 (2021-05-31) x86_64 GNU/Linux',
            ifconfig: () => this.showNetwork(),
            ip: (args) => this.showIp(args),
            nmap: (args) => this.simulateNmap(args),
            python: (args) => this.runPython(args),
            python3: (args) => this.runPython(args),
            wget: (args) => this.simulateWget(args),
            curl: (args) => this.simulateCurl(args),
            ping: (args) => this.simulatePing(args),
            netstat: () => this.showNetstat(),
            ps: () => this.showProcesses(),
            mkdir: (args) => this.makeDirectory(args),
            touch: (args) => this.touchFile(args),
            rm: (args) => this.removeFile(args),
            nano: (args) => '[Nano editor would open here]\nUse \'cat\' to view files and \'echo > file\' to write',
            vim: (args) => '[Vim would open here]\nTip: Use \'cat\' to view files in this simulated environment',
            history: () => this.commandHistory.slice(-20).map((cmd, i) => `${i + 1}  ${cmd}`).join('\n'),
            banner: () => this.showBanner(),
            sqlmap: (args) => this.simulateSqlmap(args),
            metasploit: () => '[*] Metasploit Framework Console\n[*] msfconsole would launch here\n[*] This is a simulated environment - use real tools on authorized targets only',
            msfconsole: () => '[*] Metasploit Framework\n[*] This is a simulated environment',
            burp: () => '[*] Burp Suite would launch here\n[*] Remember: Only test applications you have permission to test',
            burpsuite: () => '[*] Burp Suite Professional\n[*] Would open GUI in real environment',
            hydra: (args) => this.simulateHydra(args),
            nikto: (args) => this.simulateNikto(args),
            gobuster: (args) => this.simulateGobuster(args),
            dirb: (args) => this.simulateDirb(args),
            dig: (args) => this.simulateDig(args),
            nslookup: (args) => this.simulateNslookup(args),
            whois: (args) => this.simulateWhois(args),
            grep: (args) => '[grep] Pattern matching tool\nUsage: cat file.txt | grep pattern',
            find: (args) => this.simulateFind(args),
            sudo: (args) => this.executeSudo(args),
            apt: (args) => '[apt] Package manager\nThis is a simulated environment - packages are pre-installed',
            'apt-get': (args) => '[apt-get] Package manager\nAll required packages are already installed',
            git: (args) => this.simulateGit(args),
            ssh: (args) => this.simulateSsh(args),
            nc: (args) => '[nc] Netcat - Network utility\nUsage: nc -lvp 4444 (would open listener)',
            netcat: (args) => '[Netcat] Network Swiss Army knife\nSimulated environment',
            chmod: (args) => args.length > 0 ? `Changed permissions of ${args[args.length - 1]}` : 'chmod: missing operand',
            chown: (args) => args.length > 0 ? `Changed owner of ${args[args.length - 1]}` : 'chown: missing operand',
            tree: () => this.showTree(),
            man: (args) => args.length > 0 ? `Manual page for ${args[0]}\n(Use \'help\' to see available commands)` : 'What manual page do you want?'
        };

        this.init();
    }

    init() {
        this.showBanner();
        this.prompt();

        this.term.onData((data) => {
            switch (data) {
                case '\r': // Enter
                    this.term.write('\r\n');
                    this.executeCommand(this.currentLine.trim());
                    this.currentLine = '';
                    this.prompt();
                    break;
                case '\u007F': // Backspace
                    if (this.currentLine.length > 0) {
                        this.currentLine = this.currentLine.slice(0, -1);
                        this.term.write('\b \b');
                    }
                    break;
                case '\u0003': // Ctrl+C
                    this.term.write('^C\r\n');
                    this.currentLine = '';
                    this.prompt();
                    break;
                case '\u001b[A': // Up arrow
                    // Command history
                    break;
                default:
                    if (data >= String.fromCharCode(0x20) && data <= String.fromCharCode(0x7E)) {
                        this.currentLine += data;
                        this.term.write(data);
                    }
            }
        });

        window.addEventListener('resize', () => {
            this.fitAddon.fit();
        });
    }

    showBanner() {
        const banner = `
\x1b[32m╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║  ███╗   ██╗██╗   ██╗██╗     ██╗     ███████╗███████╗ ██████╗║
║  ████╗  ██║██║   ██║██║     ██║     ██╔════╝██╔════╝██╔════╝║
║  ██╔██╗ ██║██║   ██║██║     ██║     ███████╗█████╗  ██║     ║
║  ██║╚██╗██║██║   ██║██║     ██║     ╚════██║██╔══╝  ██║     ║
║  ██║ ╚████║╚██████╔╝███████╗███████╗███████║███████╗╚██████╗║
║  ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝╚══════╝ ╚═════╝║
║                                                              ║
║              Kali Linux Lab Environment                      ║
║              Type 'help' for available commands              ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝\x1b[0m

\x1b[33m[!] WARNING: This is a simulated environment for learning purposes\x1b[0m
\x1b[33m[!] Always practice ethical hacking - get permission first!\x1b[0m

`;
        this.term.write(banner);
    }

    prompt() {
        const promptStr = `\r\n\x1b[32m┌──(\x1b[34m${this.username}@${this.hostname}\x1b[32m)-[\x1b[37m${this.currentDir}\x1b[32m]\r\n└─\x1b[34m$\x1b[0m `;
        this.term.write(promptStr);
    }

    executeCommand(input) {
        if (!input) return;

        this.commandHistory.push(input);
        const parts = input.split(' ');
        const cmd = parts[0];
        const args = parts.slice(1);

        if (this.commands[cmd]) {
            const output = this.commands[cmd](args);
            if (output) {
                this.term.write(output + '\r\n');
            }
        } else {
            this.term.write(`bash: ${cmd}: command not found\r\n`);
        }
    }

    showHelp() {
        return `\x1b[36mAvailable Commands:\x1b[0m
  \x1b[32mFile System:\x1b[0m ls, cd, pwd, cat, mkdir, touch, rm
  \x1b[32mSystem Info:\x1b[0m whoami, hostname, uname, date, ps, ifconfig
  \x1b[32mNetwork:\x1b[0m ping, nmap, netstat, wget, curl
  \x1b[32mHacking Tools:\x1b[0m sqlmap, metasploit, burp, hydra
  \x1b[32mOther:\x1b[0m clear, history, help, banner
  
\x1b[33mNote: This is a simulated environment. All "scans" and "exploits" are fake.\x1b[0m`;
    }

    listFiles(args) {
        const dir = this.fileSystem[this.currentDir];
        if (!dir || dir.type !== 'dir') {
            return 'ls: cannot access directory';
        }
        return dir.contents.join('  ');
    }

    printWorkingDir() {
        return this.currentDir;
    }

    changeDirectory(args) {
        if (args.length === 0) {
            this.currentDir = '/home/kali';
            return '';
        }

        let newPath = args[0];
        if (newPath === '..') {
            const parts = this.currentDir.split('/').filter(p => p);
            parts.pop();
            this.currentDir = '/' + parts.join('/');
            if (this.currentDir === '/') this.currentDir = '/';
            return '';
        }

        if (!newPath.startsWith('/')) {
            newPath = this.currentDir + '/' + newPath;
        }

        if (this.fileSystem[newPath] && this.fileSystem[newPath].type === 'dir') {
            this.currentDir = newPath;
            return '';
        }

        return `cd: ${args[0]}: No such file or directory`;
    }

    catFile(args) {
        if (args.length === 0) {
            return 'cat: missing file operand';
        }

        let filePath = args[0];
        if (!filePath.startsWith('/')) {
            filePath = this.currentDir + '/' + filePath;
        }

        const file = this.fileSystem[filePath];
        if (!file) {
            return `cat: ${args[0]}: No such file or directory`;
        }

        if (file.type !== 'file') {
            return `cat: ${args[0]}: Is a directory`;
        }

        return file.content;
    }

    showNetwork() {
        return `eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.0.42  netmask 255.255.255.0  broadcast 10.10.0.255
        inet6 fe80::a00:27ff:fe4e:66a1  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:4e:66:a1  txqueuelen 1000  (Ethernet)
        RX packets 1234  bytes 123456 (120.5 KiB)
        TX packets 567  bytes 56789 (55.4 KiB)`;
    }

    simulateNmap(args) {
        if (args.length === 0) {
            return 'Nmap 7.91 ( https://nmap.org )\nUsage: nmap [Scan Type(s)] [Options] {target specification}';
        }
        return `Starting Nmap 7.91 ( https://nmap.org )
Nmap scan report for ${args[0]}
Host is up (0.00050s latency).
Not shown: 997 closed ports
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
443/tcp  open  https

Nmap done: 1 IP address (1 host up) scanned in 2.34 seconds
\x1b[33m[!] Note: This is a simulated scan. Use real nmap only with authorization.\x1b[0m`;
    }

    simulateWget(args) {
        if (args.length === 0) {
            return 'wget: missing URL';
        }
        return `--2024-12-13 12:00:00--  ${args[0]}
Resolving ${args[0]}... 93.184.216.34
Connecting to ${args[0]}|93.184.216.34|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1234 (1.2K) [text/html]
Saving to: 'index.html'

index.html          100%[===================>]   1.21K  --.-KB/s    in 0s

2024-12-13 12:00:00 (45.2 MB/s) - 'index.html' saved [1234/1234]`;
    }

    simulateCurl(args) {
        if (args.length === 0) {
            return 'curl: try \'curl --help\' for more information';
        }
        return `<!DOCTYPE html>
<html>
<head><title>Simulated Response</title></head>
<body><h1>This is a simulated HTTP response</h1></body>
</html>`;
    }

    simulatePing(args) {
        if (args.length === 0) {
            return 'ping: usage error: Destination address required';
        }
        return `PING ${args[0]} (93.184.216.34) 56(84) bytes of data.
64 bytes from ${args[0]}: icmp_seq=1 ttl=56 time=12.3 ms
64 bytes from ${args[0]}: icmp_seq=2 ttl=56 time=11.8 ms
64 bytes from ${args[0]}: icmp_seq=3 ttl=56 time=12.1 ms
^C
--- ${args[0]} ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms`;
    }

    makeDirectory(args) {
        if (args.length === 0) {
            return 'mkdir: missing operand';
        }
        return `mkdir: created directory '${args[0]}'`;
    }

    touchFile(args) {
        if (args.length === 0) {
            return 'touch: missing file operand';
        }
        return '';
    }

    removeFile(args) {
        if (args.length === 0) {
            return 'rm: missing operand';
        }
        return `rm: removed '${args[0]}'`;
    }

    showNetstat() {
        return `Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN     
tcp        0      0 10.10.0.42:22           10.10.0.1:54321         ESTABLISHED`;
    }

    showProcesses() {
        return `  PID TTY          TIME CMD
 1234 pts/0    00:00:00 bash
 5678 pts/0    00:00:01 sshd
 9012 pts/0    00:00:00 apache2
 3456 pts/0    00:00:00 ps`;
    }

    runPython(args) {
        if (args.length === 0) {
            return 'Python 3.9.7 (default, Sep 10 2021, 14:59:43)\nType "help", "copyright", "credits" or "license" for more information.\n>>> (Use Ctrl+C to exit simulation)';
        }
        return `[*] Running Python script: ${args.join(' ')}\n[*] Simulated execution complete`;
    }

    showIp(args) {
        return `1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:4e:66:a1 brd ff:ff:ff:ff:ff:ff
    inet 10.10.0.42/24 brd 10.10.0.255 scope global eth0`;
    }

    simulateSqlmap(args) {
        if (args.length === 0) {
            return `SQLMap - Automatic SQL injection tool
Usage: sqlmap -u "http://target.com/page?id=1"
Options:
  -u URL       Target URL
  --dbs        Enumerate databases
  --tables     Enumerate tables
  --dump       Dump database table entries

\x1b[33m[!] Always get written permission before testing!\x1b[0m`;
        }
        return `[*] Starting SQLMap scan on ${args[0]}
[*] Testing parameter: id
[*] Detected SQL injection vulnerability!
[*] Database: mysql
[*] Available databases: [users, admin, products]

\x1b[33m[!] This is a simulated scan - use real SQLMap only with authorization\x1b[0m`;
    }

    simulateHydra(args) {
        if (args.length === 0) {
            return 'Hydra v9.2 - Network logon cracker\nUsage: hydra -l admin -P wordlist.txt ssh://target.com\n\x1b[33m[!] Only use on systems you have permission to test!\x1b[0m';
        }
        return `Hydra v9.2 starting at ${new Date().toLocaleTimeString()}
[DATA] Attacking ${args[args.length - 1]}
[STATUS] 143.00 tries/min
[22][ssh] host: ${args[args.length - 1]}   login: admin   password: password123
[STATUS] attack finished for ${args[args.length - 1]}

\x1b[33m[!] Simulated result - never attempt unauthorized access!\x1b[0m`;
    }

    simulateNikto(args) {
        if (args.length < 2) {
            return 'Nikto - Web server scanner\nUsage: nikto -h http://target.com';
        }
        return `- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          93.184.216.34
+ Target Hostname:    ${args[1]}
+ Target Port:        80
+ Start Time:         ${new Date().toLocaleString()}
---------------------------------------------------------------------------
+ Server: Apache/2.4.41 (Ubuntu)
+ Retrieved x-powered-by header: PHP/7.4.3
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined.
+ Uncommon header 'x-custom-header' found.
+ /admin/: Admin directory found (requires authentication)
+ /backup/: Backup directory found

\x1b[33m[!] Simulated scan - use real Nikto only with permission\x1b[0m`;
    }

    simulateGobuster(args) {
        if (args.length === 0) {
            return 'Gobuster - Directory/File brute forcing tool\nUsage: gobuster dir -u http://target.com -w wordlist.txt';
        }
        return `Gobuster v3.1.0
===============================================================
[+] Url:                     http://target.com
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                wordlist.txt
===============================================================
/admin                (Status: 403) [Size: 278]
/images               (Status: 301) [Size: 314]
/uploads              (Status: 301) [Size: 316]
/backup               (Status: 200) [Size: 1234]
/dashboard            (Status: 302) [Size: 0]
===============================================================`;
    }

    simulateDirb(args) {
        if (args.length === 0) {
            return 'DIRB - Web Content Scanner\nUsage: dirb http://target.com';
        }
        return `-----------------
DIRB v2.22    
-----------------
START_TIME: ${new Date().toLocaleString()}
URL_BASE: ${args[0]}
WORDLIST_FILES: /usr/share/dirb/wordlists/common.txt

-----------------
GENERATED WORDS: 4612                                                          

---- Scanning URL: ${args[0]} ----
+ ${args[0]}/admin (CODE:403|SIZE:278)                                                                                              
+ ${args[0]}/index.html (CODE:200|SIZE:10918)                                                                                       
+ ${args[0]}/robots.txt (CODE:200|SIZE:257)                                                                                         

-----------------
END_TIME: ${new Date().toLocaleString()}
DOWNLOADED: 4612 - FOUND: 3`;
    }

    simulateDig(args) {
        if (args.length === 0) {
            return 'dig: missing domain name';
        }
        return `; <<>> DiG 9.16.1-Ubuntu <<>> ${args[0]}
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 12345
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; QUESTION SECTION:
;${args[0]}.                 IN      A

;; ANSWER SECTION:
${args[0]}.          300     IN      A       93.184.216.34

;; Query time: 23 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: ${new Date().toString()}
;; MSG SIZE  rcvd: 56`;
    }

    simulateNslookup(args) {
        if (args.length === 0) {
            return 'nslookup: missing domain name';
        }
        return `Server:         8.8.8.8
Address:        8.8.8.8#53

Non-authoritative answer:
Name:   ${args[0]}
Address: 93.184.216.34`;
    }

    simulateWhois(args) {
        if (args.length === 0) {
            return 'whois: missing domain name';
        }
        return `Domain Name: ${args[0].toUpperCase()}
Registry Domain ID: EXAMPLE-DOM
Registrar WHOIS Server: whois.example.com
Registrar URL: http://www.example.com
Updated Date: 2024-01-15T10:00:00Z
Creation Date: 2000-08-14T04:00:00Z
Registrar: Example Registrar, Inc.
Domain Status: clientTransferProhibited

\x1b[33m[!] Simulated WHOIS data\x1b[0m`;
    }

    simulateFind(args) {
        if (args.length === 0) {
            return './\n./notes.txt\n./exploit.py\n./targets.txt\n./tools\n./tools/nmap.sh\n./tools/scan.sh';
        }
        return `./notes.txt\n./tools/README.md\n./Documents/pentesting-notes.md`;
    }

    executeSudo(args) {
        if (args.length === 0) {
            return 'sudo: missing command';
        }
        const cmd = args[0];
        if (this.commands[cmd]) {
            return `[sudo] password for kali: \n${this.commands[cmd](args.slice(1))}`;
        }
        return `sudo: ${cmd}: command not found`;
    }

    simulateGit(args) {
        if (args.length === 0 || args[0] === '--version') {
            return 'git version 2.34.1';
        }
        if (args[0] === 'status') {
            return 'On branch main\nYour branch is up to date with \'origin/main\'.\n\nnothing to commit, working tree clean';
        }
        if (args[0] === 'clone') {
            return args[1] ? `Cloning into '${args[1].split('/').pop()}'...\nremote: Counting objects: 100%\nReceiving objects: 100% (1234/1234), done.` : 'fatal: You must specify a repository to clone.';
        }
        return `git: '${args[0]}' is not a git command. See 'git --help'.`;
    }

    simulateSsh(args) {
        if (args.length === 0) {
            return 'usage: ssh [-l login_name] hostname [command]';
        }
        return `Connecting to ${args[0]}...\nConnection refused (simulated)\n\x1b[33m[!] SSH connections disabled in simulated environment\x1b[0m`;
    }

    showTree() {
        return `.
├── Desktop
│   ├── projects
│   └── reports
├── Documents
│   └── pentesting-notes.md
├── Downloads
├── exploit.py
├── notes.txt
├── scripts
│   ├── web_enum.sh
│   └── dns_lookup.py
├── targets.txt
└── tools
    ├── nmap.sh
    ├── README.md
    ├── scan.sh
    └── wordlist.txt`;
    }

    destroy() {
        this.term.dispose();
    }
}
