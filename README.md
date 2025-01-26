<h1 align="center">SMART POWER</h1>

<p align="center">
  <b>A Smart IoT-Based Power Management System</b>
</p>

## 📜 OVERVIEW

Smart Power is a versatile IoT project that integrates auto and manual Bluetooth modes for controlling various devices, such as appliances. It also includes advanced features like water level monitoring and automated light adjustments using LDR sensors. The system is designed to optimize power consumption and improve user convenience.

<p align="center">
  <img src="https://github.com/user-attachments/assets/998fc8c0-da0b-4acd-bc8f-a62a7a74a074" alt="IMG_20241118_211742_790~5" width="500">
</p>

---

## ✨ FEATURES

1. **Manual Mode**:
   - Control appliances via a mobile app.

2. **Auto Mode**:
   - Automatically control appliances using sensors.

3. **Water Level Monitoring**:
   - Ultrasonic sensors measure the water level, displayed in the mobile app.

4. **Flutter Mobile App**:
   - Real-time data visualization and control.

5. **Hardware Integration**:
   - Features sensors, relays, and Bluetooth modules for seamless operation.

---
## 🚀 HOW TO USE

### Hardware Requirements
- **ESP32 microcontroller**
- **LDR Sensor**
- **Ultrasonic Sensor**
- **Relay Module**
- **LEDs**
- **Fan**
- **Bluetooth Module**

### Software Requirements
- **Flutter SDK**
- **Arduino IDE**
- **MQTT Broker** (e.g., Mosquitto)

### Steps:
1. **Set Up the Circuit**:
   Follow the circuit diagram provided here.
   
<p align="center">
  <img src="https://github.com/user-attachments/assets/7d6371a8-b8d9-4295-b440-538811d9f9f8" alt="Circuit Diagram" width="400">
</p>

2. **Flash the Code**:
   - Use the Arduino IDE to flash the ESP32 with the provided Arduino code.
   - Set up the necessary pins and MQTT topics.

3. **Run the Flutter App**:
   - Open the Flutter project in your IDE.
   - Run the app on an Android or iOS device to connect with the ESP32.




## **Flutter UI**

![Screenshot_20241015-173824~2](https://github.com/user-attachments/assets/220dd094-90dd-401d-97c8-dd7bdf289689)

![Screenshot_20241015-193153~3](https://github.com/user-attachments/assets/1344987f-9656-4444-a041-49bb23e89aac)


## **Features**

Automatic light and fan control based on ambient light levels using an LDR sensor.
Water level measurement using an ultrasonic sensor, with data available for automation triggers.
Real-time sensor data visualization on the ThingSpeak IoT platform.
Control of external devices such as fans and LEDs via relay modules.

## **Tech Stack**

* Arduino IDE : For Coding ESP32 Micro-Controller.
* ThingSpeak : For cloud data storage and visualization.
* Flutter : For mobile app UI and real time visualization.

## **Circuit Diagram**

![Circuit Diagram](https://github.com/user-attachments/assets/c3382b42-26e0-45c2-9836-cf9a9cdbbd9f)

## **Working**

* LDR Sensor → ESP32: Represents the light level input.
* Ultrasonic → ESP32: Measure the water level.
* ESP32 → Relay Module: Controls the relays based on light conditions.
* Relay Module → Fan/LED: Turns on or off based on the relay signal.
* ESP32 → ThingSpeak: Sends data to the cloud.
* ThingSpeak → Flutter App: Displays data.










