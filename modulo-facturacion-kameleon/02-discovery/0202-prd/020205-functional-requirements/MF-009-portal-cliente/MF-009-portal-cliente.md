# MF-009 — Portal del cliente

**Fuente**: Propuesta Fase 2 + gap 9 (Portal del cliente).

**Descripción**: Área en Kameleon (o página dedicada) para que el cliente vea y descargue sus facturas sin acceso al back-office. Acceso mediante token mágico o autenticación por cliente. Historial de facturas; descarga de PDF y de notas de crédito; evidencia de visualización. Opcional: pasarela de pago online.

**Objetivo**: Autoservicio del cliente para consultar facturas y descargar documentos.

**Alcance**: Acceso seguro (token/autenticación); listado de facturas del cliente; descarga PDF; evidencia de visualización. Excluye en v1: pasarela de pago integrada (valorar en Fase 2).

---

## Historias de usuario (índice)


| ID            | Título                                                           | Prioridad |
| ------------- | ---------------------------------------------------------------- | --------- |
| MF-009-US-001 | Acceso al portal de facturación con token mágico o login cliente | Alta      |
| MF-009-US-002 | Historial de facturas del cliente (listado con estado de pago)   | Alta      |
| MF-009-US-003 | Descargar PDF de factura y nota de crédito desde el portal       | Alta      |
| MF-009-US-004 | Registro de evidencia de visualización/descarga (auditoría)      | Media     |


> Detalle en carpeta `/stories`

