#include <ESP8266WiFi.h>
#include <WebSocketsServer.h>

// Credenciais da rede Wi-Fi
const char* ssid = "HackaTruckIoT";
const char* password = "iothacka";

// Servidor WebSocket a escutar na porta 81
WebSocketsServer webSocket(81);

void setup() {
  Serial.begin(115200);
  delay(100);

  Serial.println();
  Serial.print("A ligar à rede Wi-Fi: ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println();
  Serial.print("Wi-Fi Conectado! Endereço IP do NodeMCU: ");
  Serial.println(WiFi.localIP());

  // Iniciar o servidor WebSocket
  webSocket.begin();
  Serial.println("Servidor WebSocket iniciado na porta 81.");
}

// Função de cálculo de percentagem baseada na leitura do ADC
int calcularUmidadePercentual(int valorADC) {
  float percentual = 100.0 * ((1024.0 - (float)valorADC) / 1024.0);
  
  // Limita os valores entre 0% e 100%
  if (percentual < 0) percentual = 0;
  if (percentual > 100) percentual = 100;
  
  return (int)percentual;
}

void loop() {
  // Mantém o servidor WebSocket ativo
  webSocket.loop();

  // Leitura analógica do pino A0
  int valorADC = analogRead(A0);
  int umidadePercentual = calcularUmidadePercentual(valorADC);

  // Formatação do JSON com o valor percentual
  String json = "{\"umidade\":" + String(umidadePercentual) + "}";

  // Envio via WebSocket para todos os clientes ligados (iOS)
  webSocket.broadcastTXT(json);

  // Monitorização no Terminal Serial
  Serial.print("[ADC A0]: ");
  Serial.print(valorADC);
  Serial.print(" | [Enviado via WebSocket]: ");
  Serial.println(json);

  delay(2000);
}