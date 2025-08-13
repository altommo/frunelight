import time
import dxcam
import pynput
import csv
import os

# --- Configuration ---
OUTPUT_DIR = "data"
VIDEO_FILENAME = "screen_recording.mp4"
INPUT_FILENAME = "input_log.csv"

# --- Global Variables ---
camera = None
mouse_listener = None
keyboard_listener = None
csv_file = None
csv_writer = None

# --- Functions ---
def on_press(key):
    """Callback function for keyboard press events."""
    try:
        log_input("key_press", key.char)
    except AttributeError:
        log_input("key_press", str(key))

def on_release(key):
    """Callback function for keyboard release events."""
    log_input("key_release", str(key))

def on_move(x, y):
    """Callback function for mouse move events."""
    log_input("mouse_move", f"{x},{y}")

def on_click(x, y, button, pressed):
    """Callback function for mouse click events."""
    action = "mouse_press" if pressed else "mouse_release"
    log_input(action, f"{x},{y},{str(button)}")

def on_scroll(x, y, dx, dy):
    """Callback function for mouse scroll events."""
    log_input("mouse_scroll", f"{x},{y},{dx},{dy}")

def log_input(event_type, value):
    """Logs an input event to the CSV file."""
    global csv_writer
    if csv_writer:
        timestamp = time.time()
        csv_writer.writerow([timestamp, event_type, value])

def start_recording():
    """Starts the screen recording and input logging."""
    global camera, mouse_listener, keyboard_listener, csv_file, csv_writer

    # Create output directory if it doesn't exist
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    # Initialize screen recording
    camera = dxcam.create()
    video_path = os.path.join(OUTPUT_DIR, VIDEO_FILENAME)
    camera.start(target_fps=60, video_path=video_path)
    print(f"Screen recording started. Saving to {video_path}")

    # Initialize input logging
    input_path = os.path.join(OUTPUT_DIR, INPUT_FILENAME)
    csv_file = open(input_path, "w", newline="")
    csv_writer = csv.writer(csv_file)
    csv_writer.writerow(["timestamp", "event_type", "value"])
    print(f"Input logging started. Saving to {input_path}")

    # Start listening to mouse and keyboard events
    mouse_listener = pynput.mouse.Listener(
        on_move=on_move, on_click=on_click, on_scroll=on_scroll
    )
    keyboard_listener = pynput.keyboard.Listener(
        on_press=on_press, on_release=on_release
    )
    mouse_listener.start()
    keyboard_listener.start()

def stop_recording():
    """Stops the screen recording and input logging."""
    global camera, mouse_listener, keyboard_listener, csv_file

    # Stop screen recording
    if camera:
        camera.stop()
        print("Screen recording stopped.")

    # Stop input logging
    if mouse_listener:
        mouse_listener.stop()
    if keyboard_listener:
        keyboard_listener.stop()
    if csv_file:
        csv_file.close()
        print("Input logging stopped.")

# --- Main Execution ---
if __name__ == "__main__":
    print("Starting data collection in 3 seconds...")
    time.sleep(3)

    start_recording()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        stop_recording()
        print("Data collection complete.")
