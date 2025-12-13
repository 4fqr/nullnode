# Quick Manual Test Commands

# 1. Build the image
docker build -t nullsector/lab:latest -f Dockerfile.lab.alpine .

# 2. Test run (opens terminal at http://localhost:7681)
docker run -p 7681:7681 --rm nullsector/lab:latest

# 3. Test with isolated network (production mode)
docker run -p 7681:7681 --rm --network none nullsector/lab:latest

# 4. Check what's installed
docker run --rm nullsector/lab:latest bash -c "nmap --version && python3 --version && node --version"

# 5. Check image size
docker images nullsector/lab:latest

# 6. Test OWASP Juice Shop (in separate terminals)
# Terminal 1:
docker run -p 7681:7681 -p 3000:3000 --rm nullsector/lab:latest bash -c "cd /opt/juice-shop && npm start"
# Terminal 2: Open http://localhost:3000

# 7. Cleanup
docker stop $(docker ps -q --filter ancestor=nullsector/lab:latest)
docker rmi nullsector/lab:latest
