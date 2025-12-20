#!/usr/bin/env python3
"""
Script to update mobile app server URL after deployment
"""

import os
import re

def update_server_url(new_url):
    """Update the server URL in mobile app"""
    
    api_service_path = "mobile/lib/services/api_service.dart"
    
    if not os.path.exists(api_service_path):
        print(f"❌ File not found: {api_service_path}")
        return False
    
    # Read the file
    with open(api_service_path, 'r', encoding='utf-8') as file:
        content = file.read()
    
    # Update the baseUrl
    old_pattern = r"static const String baseUrl = '[^']*';"
    new_line = f"static const String baseUrl = '{new_url}/api';"
    
    updated_content = re.sub(old_pattern, new_line, content)
    
    # Write back to file
    with open(api_service_path, 'w', encoding='utf-8') as file:
        file.write(updated_content)
    
    print(f"✅ Updated mobile app server URL to: {new_url}/api")
    return True

def main():
    print("📱 MOBILE APP SERVER URL UPDATER")
    print("=================================")
    print()
    
    print("🌐 Common deployment URLs:")
    print("   Railway: https://your-project-name.railway.app")
    print("   Render:  https://your-app-name.onrender.com")
    print("   Heroku:  https://your-app-name.herokuapp.com")
    print()
    
    new_url = input("🔗 Enter your deployed server URL (without /api): ").strip()
    
    if not new_url:
        print("❌ No URL provided. Exiting.")
        return
    
    # Remove trailing slash and /api if present
    new_url = new_url.rstrip('/')
    if new_url.endswith('/api'):
        new_url = new_url[:-4]
    
    if update_server_url(new_url):
        print()
        print("✅ SUCCESS! Mobile app updated with new server URL")
        print()
        print("🔧 Next steps:")
        print("1. Test the server URL in browser")
        print("2. Build mobile app: flutter build apk --release")
        print("3. Test the mobile app with new server")
        print()
        print(f"🧪 Test your server: {new_url}/api/health")
    else:
        print("❌ Failed to update mobile app")

if __name__ == "__main__":
    main()