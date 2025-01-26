<h1 align="center">SMART POWER</h1>
<p align="center">
  <b>A SMART IOT BASED POWER MANAGEMENT SYSTEM.</b>
</p>


## 🌟 OVERVIEW
Smart Power is a versatile IoT project that integrates auto and manual modes for controlling various devices, such as any type of appliances. It also includes advanced features like water level monitoring and automated light adjustments using LDR sensors. The system is designed to optimize power consumption and improve user convenience.

<p align="center">
  <img src="https://github.com/user-attachments/assets/ba3c0a5f-30d9-4069-89d7-d145b5807515" alt="IMG_20241118_211742_790~5" width="500">
</p>

--------------------------------------------
## ✨ FEATURES
1. MANUAL MODE:
   - Control connected appliances via a mobile application.
2. AUTO MODE:
   - Automatically control appliances using sensors.
3. WATER LEVEL MONITORING:
   - Ultrasonic sensors measure the water level, displayed in the mobile app.
4. FLUTTER MOBILE APP:
   - Real-time data visualization and control.
5. HARDWARE INTEGRATION:
   - Features sensors, relays, and Bluetooth modules for seamless operation.

------------------------------------------------------------
## 🚀 HOW TO USE
   HARDWARE REQUIREMENTS:
   - ESP32 Microcontroller
   - LDR Sensor
   - Ultrasonic Sensor
   - Relay Module
    
  SOFTWARE REQUIREMENTS:
   - Flutter SDK
   - Arduino IDE
   - MQTT BROKER

------------------------------------------------------------------------
 ## 🔧 STEPS TO CONFIGURE
1. SET UP THE CIRCUIT:  
   Here Is Pins Connection Of Hardware. 
  - ULTRASONIC SENSOR (HCSR04)
  
| **PIN**           | **CONNECTION (ESP32)** |
|-------------------------|------------------|
| **VCC**           | 5V                     |
| **GND**           | GND                    |
| **TrigPin**       | GPIO 5                 |
| **EchoPin**       | GPIO 18                |

- LDR SENSOR 

| **PIN**           | **CONNECTION (ESP32)** |
|-------------------|------------------------|
| **VCC**           | 3.3V                   |
| **GND**           | GND                    |
| **Analog**        | GPIO 34                |

- RELAY MODULE (2 CHANNEL)
  
| **PIN**           | **CONNECTION (ESP32)** |
|-------------------------|------------------|
| **VCC**           | 5V                     |
| **GND**           | GND                    |
| **IN1**           | GPIO 25                 |
| **IN2**           | GPIO 26                |

2. FLASH THE CODE:
   - Use the Arduino IDE to flash the ESP32 with the provided Arduino code.
   - Set up the necessary pins and MQTT topics.

3. RUN THE FLUTTER APP:
   - Open the Flutter project in your IDE.
   - Run the app on an Android or iOS device to connect with the ESP32.
  
-------------------------------------------------------------------------------
## 📊 MOBILE APP
   - Here is our Flutter based mobile application.

<p align="center">
  <img src="https://github.com/user-attachments/assets/5ee45fd7-467e-48bc-8ee1-a002fa43e4fb" alt="Image" width="200" height="500">
</p>

---------------------------------------------------------------------
## 🛠️ TECHNOLOGY USED
1. **IoT**: ESP32 for hardware integration.
2. **Flutter**: Mobile app development.
3. **MQTT Protocol**: For data communication.
4. **Arduino-IDE**: To program the Microcontroller.

----------------------------------------------------------------------
## 💡 FUTURE IMPROVEMENTS
1. Solar Panel integration for renewable energy management.
2. Implement machine learning for predictive power usage.
3. Extend support for smart home devices like ACs or heaters.

------------------------------------------------------------------------
## 📜 LICENSE
This project is licensed under the MIT License.  
See License File For More Detail.

-----------------------------------------------------------------------
## 🤝 CONTRIBUTIONS
We welcome contributions!  
Feel free to open an issue or submit a pull request.

------------------------------------------------------------------------
## 📞 CONTACT
For any queries, suggestions, or collaboration inquiries, feel free to reach out to:  
SAHIBJOT SINGH  
[sahibjotmundi000@gmail.com]





