<h1 align="center">SMART POWER</h1>
<p align="center">
  <b>A SMART IOT BASED POWER MANAGEMENT SYSTEM.</b>
</p>

## 📜 OVERVIEW

Smart Power is a versatile IoT project that integrates auto and manual Bluetooth modes for controlling various devices, such as appliances. It also includes advanced features like water level monitoring and automated light adjustments using LDR sensors. The system is designed to optimize power consumption and improve user convenience.

<p align="center">
  <img src="https://github.com/user-attachments/assets/998fc8c0-da0b-4acd-bc8f-a62a7a74a074" alt="IMG_20241118_211742_790~5" width="500">
</p>

---

## ✨ FEATURES

1. **Manual Mode**:
   -  Control connected appliances via a mobile application.
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
- **ESP32 Microcontroller**
- **LDR Sensor**
- **Ultrasonic Sensor**
- **Relay Module**
- **Appliances To Connect**

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


## 📊 MOBILE APP

<p align="center">
  <img src="https://github.com/user-attachments/assets/5ee45fd7-467e-48bc-8ee1-a002fa43e4fb" alt="Image" width="400">
</p>

## 🛠️ TECHNOLOGY USED

1. **IoT**: ESP32 Microcontroller for hardware integration.
2. **Flutter**: Mobile app development.
3. **MQTT Protocol**: For data communication.
4. **Arduino-IDE**: To program the Microcontroller.











