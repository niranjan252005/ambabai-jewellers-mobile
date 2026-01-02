#!/usr/bin/env python3
"""
Create placeholder logo files for Ambabai Jewellers
Replace these with your actual shop logo
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_placeholder_logo(size, filename, text="AJ"):
    """Create a placeholder logo with specified size"""
    
    # Create image with transparent background
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Gold color for jewelry theme
    gold_color = (212, 175, 55, 255)  # #D4AF37
    
    # Draw circular background
    margin = size // 10
    draw.ellipse([margin, margin, size-margin, size-margin], 
                fill=gold_color, outline=(180, 140, 30, 255), width=size//50)
    
    # Try to use a nice font, fallback to default
    try:
        font_size = size // 3
        font = ImageFont.truetype("arial.ttf", font_size)
    except:
        font_size = size // 4
        font = ImageFont.load_default()
    
    # Draw text in center
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    x = (size - text_width) // 2
    y = (size - text_height) // 2
    
    draw.text((x, y), text, fill=(255, 255, 255, 255), font=font)
    
    # Save the image
    img.save(filename, 'PNG')
    print(f"Created placeholder logo: {filename} ({size}x{size})")

def main():
    """Create placeholder logos"""
    
    # Ensure directories exist
    os.makedirs('assets/icon', exist_ok=True)
    os.makedirs('assets/images', exist_ok=True)
    
    # Create app icon (1024x1024)
    create_placeholder_logo(1024, 'assets/icon/app_icon.png', 'AJ')
    
    # Create logo image (512x512)  
    create_placeholder_logo(512, 'assets/images/logo.png', 'AJ')
    
    print("\n✅ Placeholder logos created!")
    print("\n📝 NEXT STEPS:")
    print("1. Replace 'assets/icon/app_icon.png' with your 1024x1024 shop logo")
    print("2. Replace 'assets/images/logo.png' with your 512x512 shop logo")
    print("3. Make sure both are PNG files with transparent backgrounds")
    print("4. Run 'flutter pub get' to refresh assets")
    print("5. Test the app to see your logo!")

if __name__ == "__main__":
    main()