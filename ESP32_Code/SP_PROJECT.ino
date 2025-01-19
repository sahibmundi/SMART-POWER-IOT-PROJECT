#include <WiFi.h>
#include <WebServer.h>
#include <PubSubClient.h>

// Wi-Fi credentials
const char* ssid = "SSID";
const char* password = "PASSWORD";

// MQTT credentials
const char* mqttServer = "mqtt3.thingspeak.com";
const int mqttPort = 1883;
const char* mqttUser = "Thingspeak User ID";
const char* mqttPassword = "ThingSpeak Password";
const char* mqttClientID = "Thingspeak Client ID";
const char* mqttTopic = "channels/Chaneel_ID/publish";

// Wi-Fi client and MQTT client
WiFiClient wifiClient;
PubSubClient mqttClient(wifiClient);

WebServer server(80);

// Pin definitions
#define RELAY_PIN_25 25 // Light control
#define RELAY_PIN_26 26 // Fan control
#define TRIG_PIN 5      // Ultrasonic sensor trigger
#define ECHO_PIN 18     // Ultrasonic sensor echo
#define LDR_PIN 34      // LDR sensor (analog input)

bool relayStatus25 = LOW; // Status of relay for light
bool relayStatus26 = LOW; // Status of relay for fan
bool autoControlMode = false; // Flag for auto control mode

unsigned long lastPublishTime = 0;
const unsigned long publishInterval = 1000; // Publish data every second

// LDR threshold value
const int LDR_THRESHOLD = 60; // Adjust the threshold value for LDR (mapped value)

// Light control based on LDR value
int mappedLDRValue = 0; // Mapped LDR value
int mappedDistance = 0;  // Global variable to store mapped distance

void setup() {
  Serial.begin(115200);

  // Set up pins
  pinMode(RELAY_PIN_25, OUTPUT);
  pinMode(RELAY_PIN_26, OUTPUT);
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  pinMode(LDR_PIN, INPUT); // Set LDR pin as input

  // Connect to Wi-Fi
  connectWiFi();

  // Set up MQTT
  mqttClient.setServer(mqttServer, mqttPort);
  mqttClient.setKeepAlive(60); // Set MQTT keep-alive interval to 60 seconds
  connectMQTT();

  // Set up server routes
  server.on("/", handle_OnConnect);
  server.on("/RELAY25toggle", handle_RELAY25toggle);
  server.on("/RELAY26toggle", handle_RELAY26toggle);
  server.on("/toggleMode", handle_ToggleMode);
  server.onNotFound(handle_NotFound);

  server.begin();
  Serial.println("HTTP server started");
}

void loop() {
  server.handleClient();

  // Reconnect to MQTT if disconnected
  if (!mqttClient.connected()) {
    connectMQTT();
  }
  mqttClient.loop();

  // Publish ultrasonic and LDR data at regular intervals
  if (millis() - lastPublishTime > publishInterval) {
    publishSensorData();
    lastPublishTime = millis();
  }

  // Control relay based on auto or manual mode
  if (autoControlMode) {
    // Automatic control based on LDR value
    int ldrValue = analogRead(LDR_PIN); // Read the LDR value
    mappedLDRValue = map(ldrValue, 0, 4095, 0, 100);
    Serial.print("LDR Value: ");
    Serial.println(ldrValue);
    Serial.print("Mapped LDR Value: ");
    Serial.println(mappedLDRValue);

    if (mappedLDRValue > LDR_THRESHOLD && relayStatus25 == LOW) {
      relayStatus25 = HIGH; // Turn light on
      digitalWrite(RELAY_PIN_25, HIGH);
      Serial.println("Light ON - LDR mapped value greater than threshold");
    } else if (mappedLDRValue <= LDR_THRESHOLD && relayStatus25 == HIGH) {
      relayStatus25 = LOW; // Turn light off
      digitalWrite(RELAY_PIN_25, LOW);
      Serial.println("Light OFF - LDR mapped value less than or equal to threshold");
    }
  } else {
    // Manual control via web server
    digitalWrite(RELAY_PIN_25, relayStatus25 ? HIGH : LOW);
  }

  // Update relay states for fan control
  digitalWrite(RELAY_PIN_26, relayStatus26 ? HIGH : LOW);
}

void connectWiFi() {
  WiFi.begin(ssid, password);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(1000);
  }
  Serial.println("\nConnected to Wi-Fi");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());
}

void connectMQTT() {
  while (!mqttClient.connected()) {
    Serial.println("Attempting MQTT connection...");
    if (mqttClient.connect(mqttClientID, mqttUser, mqttPassword)) {
      Serial.println("MQTT connected");
    } else {
      Serial.print("MQTT connection failed, rc=");
      Serial.print(mqttClient.state());
      Serial.println(". Retrying in 5 seconds...");
      delay(5000); // Retry delay
    }
  }
}

void publishSensorData() {
  int distance = calculateDistance();
  mappedDistance = map(distance, 0, 400, 0, 100); // Adjust max range (400 cm) if needed
  int ldrValue = analogRead(LDR_PIN); // Read the LDR value
  String payload = String("field1=") + mappedDistance + "&field3=" + ldrValue + "&status=MQTTPUBLISH";
  if (mqttClient.publish(mqttTopic, payload.c_str())) {
    Serial.println("Published Data: " + payload);
  } else {
    Serial.println("Failed to publish data. Reconnecting...");
    connectMQTT();
  }
}

void handle_OnConnect() {
  server.send(200, "text/html", SendHTML());
}

void handle_RELAY25toggle() {
  autoControlMode = false; // Switch to manual mode
  relayStatus25 = !relayStatus25; // Toggle relay state
  server.send(200, "text/html", SendHTML());
}

void handle_RELAY26toggle() {
  relayStatus26 = !relayStatus26; // Toggle relay state
  server.send(200, "text/html", SendHTML());
}

void handle_ToggleMode() {
  autoControlMode = !autoControlMode; // Toggle the mode
  server.send(200, "text/html", SendHTML());
}

void handle_NotFound() {
  server.send(404, "text/plain", "Not found");
}

String SendHTML() {
  String ptr = "<!DOCTYPE html><html>\n";
  ptr += "<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\">\n";
  ptr += "<title>ESP32 Control</title>\n";
  ptr += "<style>body { font-family: Arial; }</style></head>\n";
  ptr += "<body><h1>ESP32 Control</h1>\n";
  ptr += "<div>Light: " + String(relayStatus25 ? "ON" : "OFF") + "</div>\n";
  ptr += "<div>Fan: " + String(relayStatus26 ? "ON" : "OFF") + "</div>\n";
  ptr += "</body></html>";
  return ptr;
}

int calculateDistance() {
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);
  long duration = pulseIn(ECHO_PIN, HIGH);
  return duration * 0.034 / 2; // Calculate distance in cm
}
