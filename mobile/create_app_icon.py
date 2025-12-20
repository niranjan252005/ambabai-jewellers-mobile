#!/usr/bin/env python3
"""
Simple script to create an app icon for Ambabai Jewellers
Creates a 512x512 PNG with the SAJ logo
"""

try:
    from PIL import Image, ImageDraw, ImageFont
    import os
except ImportError:
    print("Installing required packages...")
    os.system("pip install Pillow")
    from PIL import Image, ImageDraw, ImageFont

def create_diamond_shape(draw, center_x, center_y, size, color):
    """Create a diamond shape representing jewelry"""
    # Diamond points
    top = (center_x, center_y - size)
    right = (center_x + size * 0.6, center_y - size * 0.3)
    bottom_right = (center_x + size * 0.4, center_y + size)
    bottom_left = (center_x - size * 0.4, center_y + size)
    left = (center_x - size * 0.6, center_y - size * 0.3)
    
    # Draw diamond
    points = [top, right, bottom_right, bottom_left, left]
    draw.polygon(points, fill=color)
    
    # Add facet lines
    facet_color = tuple(max(0, c - 50) for c in color)
    draw.line([top, (center_x, center_y + size * 0.2)], fill=facet_color, width=3)
    draw.line([left, (center_x, center_y + size * 0.2)], fill=facet_color, width=2)
    draw.line([right, (center_x, center_y + size * 0.2)], fill=facet_color, width=2)

def create_app_icon():
    # Create 512x512 image with gradient background
    size = 512
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Create gradient background (gold)
    for y in range(size):
        # Gold gradient from light to dark
        ratio = y / size
        r = int(212 - ratio * 30)  # 212 to 182
        g = int(175 - ratio * 30)  # 175 to 145
        b = int(55 - ratio * 20)   # 55 to 35
        color = (r, g, b, 255)
        draw.line([(0, y), (size, y)], fill=color)
    
    # Add circular mask
    mask = Image.new('L', (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.ellipse([20, 20, size-20, size-20], fill=255)
    
    # Apply mask to create circular icon
    img.putalpha(mask)
    
    # Draw diamond logo in center
    center_x, center_y = size // 2, size // 2
    diamond_size = 120
    create_diamond_shape(draw, center_x, center_y, diamond_size, (255, 255, 255, 255))
    
    # Add text "SAJ" below diamond
    try:
        # Try to use a nice font
        font_size = 60
        font = ImageFont.truetype("arial.ttf", font_size)
    except:
        # Fallback to default font
        font = ImageFont.load_default()
    
    text = "SAJ"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    text_x = (size - text_width) // 2
    text_y = center_y + diamond_size + 30
    
    # Draw text with shadow
    draw.text((text_x + 2, text_y + 2), text, fill=(0, 0, 0, 100), font=font)
    draw.text((text_x, text_y), text, fill=(255, 255, 255, 255), font=font)
    
    # Add sparkle effects
    sparkle_points = [
        (center_x - 80, center_y - 80),
        (center_x + 90, center_y - 60),
        (center_x - 70, center_y + 90),
        (center_x + 80, center_y + 70),
    ]
    
    for x, y in sparkle_points:
        # Draw small sparkle
        draw.ellipse([x-3, y-3, x+3, y+3], fill=(255, 255, 255, 200))
        draw.line([x-8, y, x+8, y], fill=(255, 255, 255, 150), width=2)
        draw.line([x, y-8, x, y+8], fill=(255, 255, 255, 150), width=2)
    
    return img

def main():
    print("🎨 Creating Ambabai Jewellers app icon...")
    
    # Create icon directory
    os.makedirs('assets/icon', exist_ok=True)
    
    # Generate icon
    icon = create_app_icon()
    
    # Save icon
    icon_path = 'assets/icon/app_icon.png'
    icon.save(icon_path, 'PNG')
    
    print(f"✅ App icon created: {icon_path}")
    print("📱 Icon features:")
    print("   - 512x512 resolution")
    print("   - Gold gradient background")
    print("   - Diamond jewelry symbol")
    print("   - SAJ branding")
    print("   - Sparkle effects")
    print("\n🔧 Next steps:")
    print("   1. Run: flutter packages pub get")
    print("   2. Run: flutter packages pub run flutter_launcher_icons:main")
    print("   3. Rebuild your app to see the new icon")

if __name__ == "__main__":
    main()