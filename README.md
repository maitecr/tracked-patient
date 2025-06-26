# Tracked Paciente

Projeto desenvolvido como atividade avaliativa no curso de Análise e Desenvolvimento de sistemas. Consiste em um aplicativo mobile para envio de rastreio em tempo, permitindo sua execução em segundo plano.

A aplicação envia o posicionamento geografico para o Firebase para que o dispositivo possa ser monitorado em tempo real pela aplicação "Track", disponível [neste repositório](https://github.com/maitecr/track-person)

## Como executar

This project is a starting point for a Flutter application.
* Alterar URL do firebase no caminho:
```
lib\services\background_service.dart
```
* Instalar dependências: `flutter pub get`
* Executar código: `flutter run`
