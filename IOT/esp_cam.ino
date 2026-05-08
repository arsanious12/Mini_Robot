#include "esp_camera.h"
#include <WiFi.h>
#include <WebSocketsClient.h>
#include <ESPmDNS.h>

const char* ssid     = "S25 Ultra"; 
const char* password = "00000000";

const char* serverHostname = "Mahmoud";
String serverIP = "";
const int wsPort = 8000;
const char* wsPath = "/ws/esp_cam";

#define PWDN_GPIO_NUM     32
#define RESET_GPIO_NUM    -1
#define XCLK_GPIO_NUM      0
#define SIOD_GPIO_NUM     26
#define SIOC_GPIO_NUM     27
#define Y9_GPIO_NUM       35
#define Y8_GPIO_NUM       34
#define Y7_GPIO_NUM       39
#define Y6_GPIO_NUM       36
#define Y5_GPIO_NUM       21
#define Y4_GPIO_NUM       19
#define Y3_GPIO_NUM       18
#define Y2_GPIO_NUM        5
#define VSYNC_GPIO_NUM    25
#define HREF_GPIO_NUM     23
#define PCLK_GPIO_NUM     22

WebSocketsClient webSocket;
bool wsConnected = false;
bool isPaused = false;

unsigned long pauseStartTime = 0;
const unsigned long PAUSE_DURATION = 5000;

int frameCount = 0;
unsigned long lastFpsTime = 0;

void sendFrame() {
  camera_fb_t* fb = esp_camera_fb_get();

  if (!fb) {
    Serial.println("Camera capture failed");
    return;
  }

  webSocket.sendBIN(fb->buf, fb->len);
  esp_camera_fb_return(fb);

  frameCount++;
  if (millis() - lastFpsTime >= 1000) {
    Serial.printf("FPS: %d\n", frameCount);
    frameCount = 0;
    lastFpsTime = millis();
  }
}

void onWebSocketEvent(WStype_t type, uint8_t* payload, size_t length) {
  switch (type) {
    case WStype_CONNECTED:
      Serial.println("WebSocket Connected");
      wsConnected = true;
      break;

    case WStype_DISCONNECTED:
      Serial.println("WebSocket Disconnected");
      wsConnected = false;
      break;

    case WStype_TEXT:
      if (length > 0 && payload[0] == 'W') {
        isPaused = true;
        pauseStartTime = millis();
        Serial.println("Pause command received");
      }
      break;

    default:
      break;
  }
}

void setupCamera() {
  camera_config_t config;

  config.ledc_channel = LEDC_CHANNEL_0;
  config.ledc_timer   = LEDC_TIMER_0;

  config.pin_d0 = Y2_GPIO_NUM;
  config.pin_d1 = Y3_GPIO_NUM;
  config.pin_d2 = Y4_GPIO_NUM;
  config.pin_d3 = Y5_GPIO_NUM;
  config.pin_d4 = Y6_GPIO_NUM;
  config.pin_d5 = Y7_GPIO_NUM;
  config.pin_d6 = Y8_GPIO_NUM;
  config.pin_d7 = Y9_GPIO_NUM;

  config.pin_xclk = XCLK_GPIO_NUM;
  config.pin_pclk = PCLK_GPIO_NUM;
  config.pin_vsync = VSYNC_GPIO_NUM;
  config.pin_href = HREF_GPIO_NUM;

  config.pin_sccb_sda = SIOD_GPIO_NUM;
  config.pin_sccb_scl = SIOC_GPIO_NUM;

  config.pin_pwdn  = PWDN_GPIO_NUM;
  config.pin_reset = RESET_GPIO_NUM;

  config.xclk_freq_hz = 20000000;

  config.pixel_format = PIXFORMAT_JPEG;
  config.frame_size   = FRAMESIZE_VGA;  
  config.jpeg_quality = 10;
  config.fb_count     = psramFound() ? 2 : 1;

  if (esp_camera_init(&config) != ESP_OK) {
    Serial.println("Camera init failed");
    return;
  }

  sensor_t * s = esp_camera_sensor_get();

  s->set_brightness(s, 1);
  s->set_contrast(s, 1);
  s->set_saturation(s, 1);
  s->set_sharpness(s, 2);

  s->set_gainceiling(s, (gainceiling_t)6);
  s->set_exposure_ctrl(s, 1);
  s->set_aec2(s, 1);
  s->set_ae_level(s, 0);

  Serial.println("Camera initialized (High Quality Mode)");
}

void connectWiFi() {
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");

  while (WiFi.status() != WL_CONNECTED) {
    delay(300);
    Serial.print(".");
  }

  Serial.println("\nWiFi connected");
  Serial.println(WiFi.localIP());
}

void resolveServer() {
  if (!MDNS.begin("esp32cam")) {
    Serial.println("mDNS failed");
  }

  IPAddress ip;

  Serial.println("Resolving server...");

  while (true) {
    ip = MDNS.queryHost(serverHostname);

    if (ip.toString() != "0.0.0.0") break;

    Serial.println("Retrying...");
    delay(2000);
  }

  serverIP = ip.toString();
  Serial.print("Server IP: ");
  Serial.println(serverIP);
}

void setup() {
  Serial.begin(115200);

  setupCamera();
  connectWiFi();
  resolveServer();

  webSocket.begin(serverIP, wsPort, wsPath);
  webSocket.onEvent(onWebSocketEvent);
  webSocket.setReconnectInterval(2000);
}

void loop() {
  webSocket.loop();

  if (isPaused && millis() - pauseStartTime >= PAUSE_DURATION) {
    isPaused = false;
    Serial.println("Resuming stream");
  }

  if (wsConnected && !isPaused) {
    sendFrame();
  }
}