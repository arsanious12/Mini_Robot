#include <Arduino.h>
#include <WiFi.h>
#include <WebSocketsClient.h>
#include <driver/i2s.h>
#include <ESPmDNS.h> 

#define RXD2 16
#define TXD2 17

const char* WIFI_SSID = "S25 Ultra";
const char* WIFI_PASS = "00000000";

const char* SERVER_HOSTNAME = "Mahmoud"; 
String serverIP = "";
const int SERVER_PORT = 8000;

#define I2S_PORT        I2S_NUM_0
#define I2S_BCLK        26
#define I2S_LRC         25
#define I2S_DOUT        22
#define SAMPLE_RATE     22050
#define BITS_PER_SAMPLE 16
#define CHANNELS        1

WebSocketsClient wsClient;
bool wsConnected = false;


void i2s_init() {
    i2s_config_t config = {
        .mode                 = (i2s_mode_t)(I2S_MODE_MASTER | I2S_MODE_TX),
        .sample_rate          = SAMPLE_RATE,
        .bits_per_sample      = I2S_BITS_PER_SAMPLE_16BIT,
        .channel_format       = I2S_CHANNEL_FMT_ONLY_LEFT,
        .communication_format = I2S_COMM_FORMAT_STAND_I2S,
        .intr_alloc_flags     = ESP_INTR_FLAG_LEVEL1,
        .dma_buf_count        = 8,
        .dma_buf_len          = 512,
        .use_apll             = false,
        .tx_desc_auto_clear   = true
    };

    i2s_pin_config_t pins = {
        .bck_io_num   = I2S_BCLK,
        .ws_io_num    = I2S_LRC,
        .data_out_num = I2S_DOUT,
        .data_in_num  = I2S_PIN_NO_CHANGE
    };

    i2s_driver_install(I2S_PORT, &config, 0, NULL);
    i2s_set_pin(I2S_PORT, &pins);
    i2s_zero_dma_buffer(I2S_PORT);

    Serial.println("I2S initialized");
}


void play_pcm(const uint8_t* data, size_t len) {
    size_t written = 0;
    i2s_write(I2S_PORT, data, len, &written, portMAX_DELAY);
}

void onWebSocketEvent(WStype_t type, uint8_t* payload, size_t length) {
    switch (type) {

        case WStype_CONNECTED:
            wsConnected = true;
            Serial.println("WebSocket connected to server");
            break;

        case WStype_DISCONNECTED:
            wsConnected = false;
            Serial.println("WebSocket disconnected, retrying...");
            break;

        case WStype_BIN:
            Serial.printf("Received %d bytes → playing audio\n", length);
            play_pcm(payload, length);
            break;

        case WStype_TEXT:
            Serial.printf("Text received: %s\n", (char*)payload);
            Serial2.println((char*)payload);
            break;

        case WStype_ERROR:
            Serial.println("WebSocket error");
            break;

        default:
            break;
    }
}

#define LED_PIN 2

void setup() {
    Serial.begin(115200);
    delay(500);
    
    pinMode(LED_PIN, OUTPUT);
    digitalWrite(LED_PIN, LOW);

    Serial2.begin(9600, SERIAL_8N1, RXD2, TXD2);
    Serial.println("ESP32 Sender Ready");

    Serial.printf("Connecting to %s ...\n", WIFI_SSID);
    WiFi.begin(WIFI_SSID, WIFI_PASS);

    while (WiFi.status() != WL_CONNECTED) {
        digitalWrite(LED_PIN, !digitalRead(LED_PIN)); // Toggle LED fast
        delay(250);
        Serial.print(".");
    }
    
    digitalWrite(LED_PIN, HIGH); 
    Serial.printf("\nWiFi connected! IP: %s\n", WiFi.localIP().toString().c_str());

    i2s_init();

    if (MDNS.begin("speaker-esp32")) {
        Serial.println("mDNS responder started");
    }

    IPAddress resolvedIP = MDNS.queryHost(SERVER_HOSTNAME); 
    
    while (resolvedIP.toString() == "0.0.0.0") {
        digitalWrite(LED_PIN, LOW); 
        delay(200);
        digitalWrite(LED_PIN, HIGH); 
        delay(1800);
        
        Serial.printf("Server '%s' not found. Trying again...\n", SERVER_HOSTNAME);
        resolvedIP = MDNS.queryHost(SERVER_HOSTNAME);
    }

    digitalWrite(LED_PIN, LOW);
    serverIP = resolvedIP.toString();
    Serial.print("Found Server at IP: ");
    Serial.println(serverIP);

    wsClient.begin(serverIP, SERVER_PORT, "/esp/ws/esp_audio");
    wsClient.onEvent(onWebSocketEvent);
    wsClient.setReconnectInterval(3000);

    Serial.println("Speaker ESP32 ready and attempting connection...");
}

void loop() {
    wsClient.loop();
}