# Lunara

Prototipo funcional de Lunara, una app premium de seguimiento del ciclo menstrual.

## Qué es esto ahora mismo

`index.html` es una sola página autocontenida (HTML/CSS/JS, sin build ni dependencias) que corre entera en el navegador:

- Motor real de predicción de ciclo (ovulación, próximo período, auto-calibración con datos reales)
- Registro de síntomas con predicción basada en historial
- Calendario, estadísticas, configuración
- Hojas modales arrastrables (Síntomas, Cuenta) con física de springs
- Cifrado en reposo (AES-GCM, `crypto.subtle`) para los datos de ciclo/síntomas guardados en el dispositivo
- Modo claro/oscuro según el sistema

Todo el almacenamiento es local (`localStorage`) — no hay backend ni cuentas reales todavía.

## Cómo probarlo

Abre `index.html` directamente en un navegador, o sirve la carpeta con cualquier servidor estático:

```bash
python3 -m http.server 8000
```

y visita `http://localhost:8000`.

## Próximos pasos (pendientes de decidir)

- Backend real (para API de IA / preguntas abiertas, cuentas, sincronización entre dispositivos)
- Migración a React Native para iOS/Android
- Compartir con pareja, notificaciones y suscripción Premium (hoy son solo visuales)
