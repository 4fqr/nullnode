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
                contents: ['home', 'etc', 'usr', 'var', 'tmp']
            },
            '/home': {
                type: 'dir',
                contents: ['kali']
            },
            '/home/kali': {
                type: 'dir',
                contents: ['Desktop', 'Documents', 'Downloads', 'tools', 'notes.txt', 'exploit.py']
            },
            '/home/kali/notes.txt': {
                type: 'file',
                content: 'Welcome to NullSector Kali Lab!\n\nRemember:\n- Always practice ethical hacking\n- Get written permission before testing\n- Use these skills for good\n\nHappy hacking!'
            },
            '/home/kali/exploit.py': {
                type: 'file',
                content: '#!/usr/bin/env python3\n# Sample exploit template\nimport socket\nimport sys\n\nprint("[*] NullSector - Ethical Hacking Lab")\nprint("[*] This is a simulated environment")\n'
            },
            '/home/kali/tools': {
                type: 'dir',
                contents: ['nmap.sh', 'scan.sh', 'README.md']
            },
            '/etc': {
                type: 'dir',
                contents: ['passwd', 'shadow', 'hosts']
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
            nmap: (args) => this.simulateNmap(args),
            python: (args) => 'Python 3.9.7 (default, Sep 10 2021, 14:59:43)\nType "help", "copyright", "credits" or "license" for more information.',
            python3: (args) => 'Python 3.9.7 (default, Sep 10 2021, 14:59:43)\nType "help", "copyright", "credits" or "license" for more information.',
            wget: (args) => this.simulateWget(args),
            curl: (args) => this.simulateCurl(args),
            ping: (args) => this.simulatePing(args),
            netstat: () => 'Active Internet connections (only servers)\nProto Recv-Q Send-Q Local Address           Foreign Address         State\ntcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN\ntcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN',
            ps: () => 'PID TTY          TIME CMD\n 1234 pts/0    00:00:00 bash\n 5678 pts/0    00:00:00 ps',
            mkdir: (args) => this.makeDirectory(args),
            touch: (args) => this.touchFile(args),
            rm: (args) => this.removeFile(args),
            history: () => this.commandHistory.join('\n'),
            banner: () => this.showBanner(),
            sqlmap: (args) => '[*] Simulated SQLMap scan\n[*] Use this tool responsibly in authorized penetration tests only',
            metasploit: () => '[*] Metasploit Framework Console\n[*] This is a simulated environment - use real tools on authorized targets only',
            burp: () => '[*] Burp Suite would launch here\n[*] Remember: Only test applications you have permission to test',
            hydra: (args) => '[*] THC-Hydra password cracker\n[*] Ethical use only - never crack passwords without authorization'
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
        return `rm: remove '${args[0]}'? (simulated)`;
    }

    destroy() {
        this.term.dispose();
    }
}
