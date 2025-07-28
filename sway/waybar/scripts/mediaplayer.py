#!/usr/bin/env python3

import sys
import json
import subprocess

def get_player_info():
    try:
        # Get current player status
        status = subprocess.run(['playerctl', 'status'], capture_output=True, text=True).stdout.strip()
        if not status:
            return None
            
        # Get metadata
        artist = subprocess.run(['playerctl', 'metadata', 'artist'], capture_output=True, text=True).stdout.strip()
        title = subprocess.run(['playerctl', 'metadata', 'title'], capture_output=True, text=True).stdout.strip()
        player = subprocess.run(['playerctl', 'metadata', 'mpris:trackid'], capture_output=True, text=True).stdout.strip()
        
        if not title:
            return None
            
        # Determine icon based on player
        icon = "default"
        if "spotify" in player.lower():
            icon = "spotify"
        elif "firefox" in player.lower():
            icon = "firefox"
        elif "chrome" in player.lower():
            icon = "chrome"
            
        # Format text
        if artist:
            text = f"{artist} - {title}"
        else:
            text = title
            
        # Truncate if too long
        if len(text) > 35:
            text = text[:32] + "..."
            
        return {
            "text": text,
            "class": f"custom-{icon}",
            "tooltip": f"{artist}\n{title}" if artist else title
        }
        
    except Exception:
        return None

if __name__ == "__main__":
    info = get_player_info()
    if info:
        print(json.dumps(info))
    else:
        print(json.dumps({"text": "", "class": "stopped"}))