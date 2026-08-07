#!/usr/bin/env python3
"""Write Nginx config with correct variable syntax"""
import subprocess
import sys

config = """server {
    listen 80;
    listen 443 ssl;
    server_name search.ibemax.com;
    
    ssl_certificate /opt/1panel/www/sites/search.ibemax.com/ssl/fullchain.pem;
    ssl_certificate_key /opt/1panel/www/sites/search.ibemax.com/ssl/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    
    add_header Cache-Control 'no-cache, no-store, must-revalidate';
    add_header Pragma 'no-cache';
    add_header Expires '0';
    
    location / {
        proxy_pass http://127.0.0.1:9999;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
"""

# Write to remote file via SSH
result = subprocess.run([
    'ssh', '-i', '~/.ssh/id_search', '-o', 'StrictHostKeyChecking=no',
    'hermes@140.245.99.56',
    'tee /etc/nginx/sites-available/search.ibemax.com > /dev/null',
    input=config
], capture_output=True, text=True)

print("STDOUT:", result.stdout)
print("STDERR:", result.stderr)
print("Return code:", result.returncode)
