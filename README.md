# Delphi MQTT Client & NTempData Example

This project is a **Delphi VCL application** demonstrating an MQTT client implementation with observer pattern support and NTempData handling for IoT-like device data. It uses **Overbyte ICS MQTT** library (v9.5) for MQTT communication.

---

## Project Structure

- **NTempData.pas**  
  Defines the `TNTempData` and `TBattery` classes to represent device data, including temperature, external temperature, battery status, and connectivity.  
  - Supports JSON serialization and deserialization (`ToJSON`, `FromJSON`)  
  - Provides a `TestInstance` method for sample data

- **MQTTClient.pas**  
  Implements `TMqttClient`, a wrapper around ICS MQTT client with:  
  - Connect, Disconnect, Subscribe, and Publish methods  
  - Observer pattern support (`IObservable` and `IObserver`)  
  - Optional logging to a file in the executable directory (`mqtt.log`)

- **Observer.pas / Observable.pas**  
  - `IObserver` interface: receives messages from MQTT topics  
  - `IObservable` interface: allows objects to subscribe for updates

- **MainForm.pas**  
  VCL form for demonstration:  
  - Displays received MQTT messages in a `TStringGrid`  
  - Provides controls for MQTT host, port, topic, and client ID  
  - Automatically handles publishing **synthetic test data** if topic is set to `ntemptest`

- **App.pas**  
  Entry point of the application. Initializes the form and MQTT client, and starts the VCL application loop.

---

## Features

- Connect to an MQTT broker and subscribe to a topic
- Publish messages or `TNTempData` JSON objects
- Observer pattern to decouple message handling from MQTT client
- Optional logging of connection, disconnection, and published messages
- GUI visualization of messages
- **Automatic test data generation**:  
  If the MQTT topic is set to `ntemptest`, the application periodically generates synthetic `TNTempData` objects using the `TestInstance` method and publishes them to the topic. This allows testing without requiring real IoT devices.

---

## Requirements

- **Delphi 10.x** or compatible RAD Studio version
- **VCL application framework**
- **Overbyte ICS 9.5** (for MQTT)
- Basic familiarity with Delphi, JSON, and MQTT concepts

---

## Usage

1. Open the project in **Delphi IDE**.
2. Ensure ICS library is installed and referenced.
3. Run the application.  
4. Configure:
   - **Host**: MQTT broker IP or hostname  
   - **Port**: Typically `1883`  
   - **Topic**: The MQTT topic to subscribe/publish  
   - **ClientID**: MQTT client identifier
5. Click **Connect** to establish MQTT connection.
6. Observe messages in the grid or publish test messages if topic is `ntemptest`.  
   - If `ntemptest` is used as the topic, the app automatically generates synthetic `TNTempData` objects and publishes them at runtime for testing purposes.

---

## Logging

Logs are optionally written to a file named `mqtt.log` in the same directory as the executable.  
To enable logging, set `LOG_ENABLE` to `True` in `TMqttClient` class.

---

## JSON Example

A `TNTempData` JSON object looks like this:

```json
{
  "transactionID": "fh67d8b0-yh86-88kk-94sd-glyv5c147778",
  "timestamp": "2025-09-25T14:00:00",
  "devID": "1",
  "userData": "Animal-1",
  "temp": 36.5,
  "extTemp": 22.3,
  "connected": true,
  "battery": {
    "level": 85,
    "charging": true
  }
}
