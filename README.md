# snoopy-le-sabe

## Miembros del proyecto:
- Luisamaria Gomez (@luisamariag)
- Paula Téllez (@marute0)
- Alejandro Leal (@ALELOY257)

## Descripción general
Este proyecto consiste en una prueba de concepto de un carro autónomo implementado sobre FPGA. El sistema utiliza un sensor LIDAR para detectar obstáculos, toma decisiones de dirección con base en esa información y muestra telemetría y alertas visuales en una matriz LED.

## Funcionamiento del sistema
El carro adquiere información del entorno mediante el sensor LIDAR, que permite estimar la cercanía de obstáculos. A partir de esos datos, la lógica de control decide si el vehículo puede continuar avanzando o si debe cambiar de dirección para evitar una colisión.

De manera paralela, el sistema genera información de telemetría, como la velocidad estimada y la distancia detectada, y la envía a la matriz LED. Esta interfaz visual permite representar el estado del vehículo mediante valores numéricos, patrones visuales o colores asociados al nivel de proximidad de una pared u obstáculo.

## Arquitectura general
El sistema puede dividirse en los siguientes bloques funcionales:

1. *Procesamiento y control*
   - Sensores
   - Drivers

3. *Visualización y telemetría*
   - Control de la matriz LED.
   - Indicadores visuales de proximidad, velocidad y alertas.

## Hardware utilizado
- FPGA Colorlight 5A-75E
- 2 Motores y driver de motor
- Matriz LED 64x64
- Sensor LIDAR
- Sensor Hall

## Comportamiento esperado
El sistema debe leer continuamente la distancia medida por el LIDAR. Cuando se detecte un obstáculo por debajo de un umbral definido, la lógica de control deberá modificar la dirección del carro, a partir de la variación de la dirección de ambos motores para evitar la colisión.

Al mismo tiempo, la matriz LED deberá mostrar información útil para el usuario, por ejemplo:
- *Verde*: distancia segura
- *Amarillo*: proximidad media
- *Rojo*: obstáculo demasiado cercano

Además, la pantalla podrá mostrar variables de telemetría como:
- Velocidad
- Valor de PWM
- Distancia al obstáculo más cercano
 

## Estructura de carpetas
```text
rtl/           -> módulos de diseño en FPGA

