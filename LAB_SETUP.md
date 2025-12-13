# NullSector Lab Setup Guide

## Overview

NullSector Lab provides ephemeral, isolated hacking environments via Docker containers. Users receive one-time access codes from a Discord bot, which spawn temporary lab sessions with full Kali Linux tooling.

## System Architecture

```
Discord Bot (Issues Codes)
      ↓
[POST /api/lab/generate-code]
      ↓
Express Server (lab-server.js)
      ↓
Docker Engine (spawns containers)
      ↓
User Access (ttyd terminal via browser)
```

## Prerequisites

- **Node.js** >= 16.0.0
- **Docker** >= 20.10.0
- **npm** >= 8.0.0
- **Linux/macOS** (or WSL2 on Windows)
- **Docker socket access** (user in docker group)

## Installation

### 1. Install Dependencies

```bash
npm install
```

### 2. Build Docker Lab Image

```bash
docker build -t nullsector/lab:latest -f Dockerfile.lab .
```

**Build time:** ~10-15 minutes (downloads Kali packages)

**Image size:** ~3.5 GB

### 3. Verify Image

```bash
docker images | grep nullsector/lab
```

Expected output:
```
nullsector/lab    latest    abc123def456    5 minutes ago    3.5GB
```

### 4. Test Container

```bash
docker run --rm -p 7681:7681 --network none nullsector/lab:latest
```

Open browser to `http://localhost:7681` - you should see terminal.

## Configuration

### Environment Variables

Create a `.env` file or set these in your shell:

```bash
# Server Configuration
LAB_PORT=3001                           # Port for Express server
LAB_BOT_SECRET=your_super_secret_key    # Shared secret with Discord bot

# Docker Configuration (optional)
LAB_IMAGE_NAME=nullsector/lab:latest    # Docker image to use
LAB_SESSION_DURATION=900000             # Session duration in ms (15 min)
LAB_CODE_EXPIRY=600000                  # Code expiry in ms (10 min)

# Rate Limiting (optional)
LAB_RATE_LIMIT_POINTS=3                 # Max attempts per window
LAB_RATE_LIMIT_DURATION=60              # Window duration in seconds
```

### Example .env file

```bash
LAB_PORT=3001
LAB_BOT_SECRET=change-this-to-random-64-char-string
```

**⚠️ CRITICAL:** Never commit `.env` to version control. Add to `.gitignore`:

```bash
echo ".env" >> .gitignore
```

## Running the Server

### Development Mode

```bash
npm run dev
```

(Uses nodemon for auto-reload)

### Production Mode

```bash
npm start
```

### Using PM2 (recommended for production)

```bash
npm install -g pm2
pm2 start lab-server.js --name nullsector-lab
pm2 save
pm2 startup
```

## Discord Bot Integration

### Bot Requirements

Your Discord bot needs to make HTTP requests to generate codes:

**Endpoint:** `POST http://your-server:3001/api/lab/generate-code`

**Headers:**
```json
{
  "Content-Type": "application/json",
  "Authorization": "Bearer YOUR_LAB_BOT_SECRET"
}
```

**Request Body:**
```json
{
  "userId": "discord_user_id_12345",
  "username": "DiscordUser#1234"
}
```

**Response (Success):**
```json
{
  "success": true,
  "code": "a7b3-9f2e",
  "expiresIn": 600000
}
```

### Example Bot Code (Discord.js)

```javascript
const { Client, GatewayIntentBits } = require('discord.js');
const axios = require('axios');

const client = new Client({ intents: [GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages] });

client.on('messageCreate', async (message) => {
  if (message.content === '!lab') {
    try {
      const response = await axios.post('http://your-server:3001/api/lab/generate-code', {
        userId: message.author.id,
        username: message.author.tag
      }, {
        headers: { 'Authorization': `Bearer ${process.env.LAB_BOT_SECRET}` }
      });

      message.reply(`🔐 Your lab code: **${response.data.code}**\nVisit https://nullsector.com/lab.html\nExpires in 10 minutes!`);
    } catch (error) {
      message.reply('❌ Failed to generate lab code. Try again later.');
    }
  }
});

client.login(process.env.DISCORD_TOKEN);
```

## API Endpoints

### 1. Generate Code (Bot Only)

**POST** `/api/lab/generate-code`

**Auth:** Bearer token (LAB_BOT_SECRET)

**Body:**
```json
{
  "userId": "string",
  "username": "string"
}
```

**Response:**
```json
{
  "success": true,
  "code": "xxxx-yyyy",
  "expiresIn": 600000
}
```

### 2. Claim Lab (Public)

**POST** `/api/lab/claim`

**Rate Limited:** 3 requests/minute per IP

**Body:**
```json
{
  "code": "xxxx-yyyy"
}
```

**Response:**
```json
{
  "success": true,
  "sessionId": "uuid-v4-string",
  "labUrl": "http://localhost:random-port",
  "expiresAt": 1234567890000
}
```

### 3. Check Status (Public)

**GET** `/api/lab/status/:sessionId`

**Response:**
```json
{
  "success": true,
  "active": true,
  "timeRemaining": 567890
}
```

## Firewall & Network Configuration

### Required Ports

- **3001** - Express server (HTTP API)
- **49152-65535** - Docker container ports (dynamic allocation)

### Firewall Rules (ufw)

```bash
# Allow Express server
sudo ufw allow 3001/tcp

# Allow Docker port range
sudo ufw allow 49152:65535/tcp
```

### Reverse Proxy (Nginx)

```nginx
server {
    listen 80;
    server_name labs.nullsector.com;

    # API endpoints
    location /api/lab/ {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # Static files
    location / {
        root /var/www/nullsector;
        index lab.html;
        try_files $uri $uri/ =404;
    }
}
```

## Security Considerations

### Container Isolation

Containers run with `--network none` (no internet access) and ephemeral storage:

- No external network connectivity
- No data persistence after 15 minutes
- Resource limits (512MB RAM, CPU shares)
- Read-only root filesystem (optional)

### Rate Limiting

Default: 3 code claims per minute per IP address

Adjust in `.env`:
```bash
LAB_RATE_LIMIT_POINTS=5
LAB_RATE_LIMIT_DURATION=120
```

### Secret Management

- Store `LAB_BOT_SECRET` in environment variables
- Use strong random strings (64+ characters)
- Rotate secrets periodically
- Never log secrets in production

Generate strong secret:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### Docker Security

Add Docker daemon configuration (`/etc/docker/daemon.json`):

```json
{
  "userns-remap": "default",
  "no-new-privileges": true,
  "seccomp-profile": "/etc/docker/seccomp-default.json"
}
```

## Monitoring & Logging

### View Active Sessions

```bash
# Check running containers
docker ps | grep nullsector-lab

# View logs
docker logs <container-id>
```

### Server Logs

Logs are output to stdout. In production, capture with PM2:

```bash
pm2 logs nullsector-lab
```

### Metrics

Add monitoring endpoint to `lab-server.js`:

```javascript
app.get('/api/lab/metrics', (req, res) => {
  res.json({
    activeSessions: activeSessions.size,
    activeContainers: activeSessions.size,
    totalCodes: accessCodes.size
  });
});
```

## Troubleshooting

### Issue: "Docker socket not accessible"

**Solution:** Add user to docker group:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Issue: "Port already in use"

**Solution:** Change LAB_PORT or kill conflicting process:
```bash
lsof -ti:3001 | xargs kill -9
```

### Issue: "Image build fails"

**Solution:** Check Docker disk space:
```bash
docker system df
docker system prune -a
```

### Issue: "Container won't start"

**Solution:** Check Docker logs:
```bash
docker logs <container-id>
docker inspect <container-id>
```

### Issue: "Rate limit blocks legitimate users"

**Solution:** Increase rate limit or whitelist IPs in `lab-server.js`:

```javascript
const rateLimiter = new RateLimiterMemory({
  points: 10, // Increase from 3
  duration: 60,
  keyPrefix: 'lab-claim',
  whitelist: ['127.0.0.1', '10.0.0.0/8'] // Add trusted IPs
});
```

## Maintenance

### Clean Up Orphaned Containers

```bash
# Remove stopped containers
docker container prune -f

# Remove dangling images
docker image prune -f

# Full cleanup (careful in production!)
docker system prune -a --volumes -f
```

### Update Lab Image

```bash
# Pull latest changes
git pull

# Rebuild image
docker build -t nullsector/lab:latest -f Dockerfile.lab .

# Restart server
pm2 restart nullsector-lab
```

### Database Backup (Future Enhancement)

Currently uses in-memory storage. To add persistence:

1. Install Redis: `npm install redis`
2. Replace Map objects with Redis client
3. Set TTL on keys for auto-expiry

## Testing

### Manual Testing

```bash
# 1. Generate code (simulate bot)
curl -X POST http://localhost:3001/api/lab/generate-code \
  -H "Authorization: Bearer YOUR_SECRET" \
  -H "Content-Type: application/json" \
  -d '{"userId":"test123","username":"TestUser"}'

# Expected: {"success":true,"code":"xxxx-yyyy","expiresIn":600000}

# 2. Claim lab (simulate user)
curl -X POST http://localhost:3001/api/lab/claim \
  -H "Content-Type: application/json" \
  -d '{"code":"xxxx-yyyy"}'

# Expected: {"success":true,"sessionId":"...", "labUrl":"http://localhost:xxxxx"}

# 3. Check status
curl http://localhost:3001/api/lab/status/<sessionId>

# Expected: {"success":true,"active":true,"timeRemaining":890000}
```

### Load Testing

Use Apache Bench:
```bash
ab -n 100 -c 10 -p claim.json -T application/json http://localhost:3001/api/lab/claim
```

## Production Deployment

### Systemd Service

Create `/etc/systemd/system/nullsector-lab.service`:

```ini
[Unit]
Description=NullSector Lab Server
After=network.target docker.service

[Service]
Type=simple
User=labuser
WorkingDirectory=/opt/nullsector-lab
Environment="LAB_PORT=3001"
Environment="LAB_BOT_SECRET=your_secret_here"
ExecStart=/usr/bin/node lab-server.js
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl daemon-reload
sudo systemctl enable nullsector-lab
sudo systemctl start nullsector-lab
```

### Docker Compose (Alternative)

```yaml
version: '3.8'
services:
  lab-server:
    build:
      context: .
      dockerfile: Dockerfile.server
    ports:
      - "3001:3001"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - LAB_PORT=3001
      - LAB_BOT_SECRET=${LAB_BOT_SECRET}
    restart: unless-stopped
```

## Support

- **Issues:** https://github.com/nullsector/nullnode/issues
- **Discord:** https://discord.gg/nullsector
- **Docs:** https://nullsector.com/docs

## License

MIT License - See LICENSE file for details
