# Security

## 1. Modelo de amenazas y superficie

### Metodología aplicada: STRIDE + LINDDUN

**Supuestos del modelo:**
- Sistema web-based con usuarios internos (empleados) y externos (clientes)
- Integración con Discord como servicio externo
- Datos sensibles: tiempo de trabajo, presupuestos, información personal
- Arquitectura cloud-native con microservicios

### Activos y datos críticos por épica

| Épica | Activos Críticos | Clasificación | Amenazas Principales |
|-------|------------------|---------------|---------------------|
| **EP-001** | Leads, contactos, datos formulario captación | Confidencial | Spoofing, Information Disclosure |
| **EP-003** | Correos automáticos, datos lead para respuesta | Confidencial | Tampering, Repudiation |
| **EP-005** | Datos reunión, notas, información para presupuesto | Confidencial | Information Disclosure, Tampering |
| **EP-006 a EP-009** | Presupuestos, contratos, firmas, costes | Sensible | Tampering, Information Disclosure, Repudiation |
| **EP-012, EP-013** | Registros de tiempo, recursos, gastos | Sensible | Tampering, Information Disclosure |
| **EP-016 a EP-018** | Material RRSS, integración Discord (si aplica), mensajes | Confidencial | Information Disclosure, Elevation of Privilege |
| **EP-019 a EP-021** | Material entregado, comentarios, galería | Confidencial | Information Disclosure |
| **EP-025 a EP-027** | Archivos, ubicación discos, retención/eliminación | Confidencial | Tampering, Information Disclosure |

### Diagrama de confianza y zonas de seguridad

```
┌─────────────────────────────────────────────────────────────┐
│                    ZONA PÚBLICA                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              CDN/Edge (Cloudflare)                  │   │
│  │  - DDoS Protection                                  │   │
│  │  - WAF (Web Application Firewall)                   │   │
│  └─────────────────┬───────────────────────────────────┘   │
│                    │                                       │
│  ┌─────────────────▼─────────────────────────────────────┐ │
│  │              ZONA DMZ                                │ │
│  │  ┌─────────────────────────────────────────────────┐ │ │
│  │  │        API Gateway (Kong/AWS ALB)              │ │ │
│  │  │  - Rate Limiting                                │ │ │
│  │  │  - Request Validation                           │ │ │
│  │  │  - JWT Validation                               │ │ │
│  │  └─────────────────┬───────────────────────────────┘ │ │
│  │                    │                                 │ │
│  │  ┌─────────────────▼───────────────────────────────┐ │ │
│  │  │          ZONA APLICACIÓN                        │ │ │
│  │  │  ┌─────────────────────────────────────────────┐ │ │
│  │  │  │     Application Layer (Node.js/React)      │ │ │
│  │  │  │  - Authentication/Authorization             │ │ │
│  │  │  │  - Input Validation                         │ │ │
│  │  │  │  - Session Management                       │ │ │
│  │  │  └─────────────────┬───────────────────────────┘ │ │
│  │                      │                               │ │
│  │  ┌────────────────────▼────────────────────────────┐ │ │
│  │  │           ZONA DE DATOS                         │ │ │
│  │  │  ┌─────────────────────────────────────────────┐ │ │
│  │  │  │      Database Layer (PostgreSQL/Redis)      │ │ │
│  │  │  │  - Encryption at Rest                       │ │ │
│  │  │  │  - Row Level Security                       │ │ │
│  │  │  │  - Audit Logging                            │ │ │
│  │  │  └─────────────────────────────────────────────┘ │ │
│  │                                                     │ │
│  └─────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 2. Controles de aplicación

### Autenticación y gestión de identidad

| Control | Implementación | Evidencia | Frecuencia |
|---------|----------------|-----------|------------|
| **SSO Integration** | OIDC con Azure AD / Auth0 | Certificado compliance, logs de autenticación | Continuo |
| **MFA Obligatorio** | TOTP + Biometric (opcional) | 90% usuarios con MFA, logs de intentos fallidos | Diaria |
| **Password Policy** | 12+ caracteres, complejidad, expiración 90 días | Configuración IAM, logs de cambios | Mensual |
| **Account Recovery** | Email + SMS con rate limiting | Logs de recuperación, alertas de abuso | Por evento |

### Autorización y control de acceso

| Control | Implementación | Evidencia | Frecuencia |
|---------|----------------|-----------|------------|
| **RBAC/ABAC** | Roles jerárquicos + atributos dinámicos | Matriz de permisos por rol, audit logs | Continuo |
| **Separation of Duties** | PM no puede modificar presupuestos | Validaciones automáticas, logs de excepciones | Por transacción |
| **Least Privilege** | Principio de mínimo privilegio | Análisis de permisos trimestral | Trimestral |
| **Access Reviews** | Revisión automática de accesos inactivos | Reportes de revisión, logs de revocación | Mensual |

### Validación y protección de entrada

| Control | Implementación | Evidencia | Frecuencia |
|---------|----------------|-----------|------------|
| **Input Validation** | Sanitización + validación de esquemas | OWASP ZAP scans, logs de ataques | Continuo |
| **XSS Protection** | Content Security Policy + escape | Headers de respuesta, logs de intentos | Continuo |
| **CSRF Protection** | Double-submit cookie + SameSite | Tokens CSRF en formularios | Continuo |
| **File Upload Security** | Validación MIME + antivirus + size limits | Logs de uploads, alertas de malware | Por upload |

### Gestión de sesiones y APIs

| Control | Implementación | Evidencia | Frecuencia |
|---------|----------------|-----------|------------|
| **Session Management** | JWT con expiración corta + refresh tokens | Logs de expiración, configuración segura | Continuo |
| **API Security** | OAuth2 + scopes granulares | Tokens con expiración, rate limiting | Continuo |
| **Rate Limiting** | Token bucket por usuario/IP | Logs de throttling, alertas de abuso | Continuo |
| **API Versioning** | Semantic versioning con deprecation warnings | Headers de versión, documentación | Por release |

## 3. Controles de datos

### Clasificación y cifrado

| Tipo de Dato | Clasificación | Cifrado en Tránsito | Cifrado en Reposo | Rotación de Claves |
|--------------|---------------|-------------------|-------------------|-------------------|
| **Datos Personales** | Sensible (GDPR) | TLS 1.3 | AES-256-GCM | Automática 90 días |
| **Registros de Tiempo** | Sensible | TLS 1.3 | AES-256-GCM | Automática 90 días |
| **Presupuestos** | Sensible | TLS 1.3 | AES-256-GCM | Automática 30 días |
| **Mensajes Discord** | Confidencial | TLS 1.3 + mTLS | AES-256-GCM | Automática 90 días |
| **Datos de Proyecto** | Confidencial | TLS 1.3 | AES-256-GCM | Automática 180 días |

### Gestión de claves y tokenización

| Control | Implementación | Evidencia | Frecuencia |
|---------|----------------|-----------|------------|
| **KMS Integration** | AWS KMS / Azure Key Vault | Certificados de cifrado, logs de acceso | Continuo |
| **Key Rotation** | Automática por tipo de dato | Logs de rotación, backup de claves | Según política |
| **Tokenización** | Datos sensibles → tokens | Mapeo seguro, logs de tokenización | Por dato sensible |
| **HSM Support** | Hardware Security Modules | Certificados HSM, logs de operaciones | Continuo |

### Mascaramiento y retención

| Control | Implementación | Evidencia | Frecuencia |
|---------|----------------|-----------|------------|
| **PII Mascaramiento** | Algoritmos de hashing + salt | Logs de enmascaramiento, reversibilidad controlada | Por exposición |
| **Data Minimization** | Recolección mínima necesaria | Análisis de datos trimestral | Trimestral |
| **Retention Policies** | Automático por tipo de dato | Logs de eliminación, compliance reports | Diaria |
| **Secure Deletion** | NIST SP 800-88 compliant | Certificados de eliminación, logs de shredding | Por eliminación |

## 4. Plataforma e infraestructura

### Hardening y configuración segura

| Control | Implementación | Evidencia | Frecuencia |
|---------|----------------|-----------|------------|
| **OS Hardening** | CIS Benchmarks, imágenes base minimalistas | Configuración CIS, vulnerability scans | Mensual |
| **Container Security** | Non-root containers, distroless images | Dockerfile scans, runtime policies | Continuo |
| **Image Scanning** | Trivy + Clair + Snyk | Vulnerability reports, blocking deploys | Por build |
| **Runtime Security** | Falco + Kubernetes policies | Alertas de runtime, logs de violaciones | Continuo |

### Red y segmentación

| Control | Implementación | Evidencia | Frecuencia |
|---------|----------------|-----------|------------|
| **Network Segmentation** | VPC/subnets por ambiente | Diagramas de red, security groups | Continuo |
| **WAF Configuration** | OWASP Core Rule Set | Logs de bloqueos, false positive rate | Diaria |
| **DDoS Protection** | Cloudflare + AWS Shield | Logs de ataques, uptime reports | Continuo |
| **Zero Trust Network** | mTLS entre servicios | Certificados mutuales, logs de handshake | Continuo |

### Gestión de secretos

| Control | Implementación | Evidencia | Frecuencia |
|---------|----------------|-----------|------------|
| **Secret Management** | HashiCorp Vault / AWS Secrets Manager | No secrets en repos, logs de acceso | Continuo |
| **Secret Rotation** | Automática + manual override | Logs de rotación, alertas de expiración | Según política |
| **Access Auditing** | Todos los accesos a secretos logueados | Audit trails, compliance reports | Continuo |
| **Environment Separation** | Secretos por ambiente | Configuración por env, logs de separación | Continuo |

### Backup y disaster recovery

| Control | Implementación | Evidencia | Frecuencia |
|---------|----------------|-----------|------------|
| **Encrypted Backups** | AES-256 + integrity checks | Backup verification, restore tests | Diaria |
| **Backup Retention** | Tiered retention (7d/30d/1y) | Compliance de retención, logs de eliminación | Mensual |
| **DR Testing** | Failover tests trimestrales | DR runbooks, recovery time objectives | Trimestral |
| **Geo-Redundancy** | Multi-region deployment | RTO/RPO metrics, failover logs | Continuo |

## 5. SDLC seguro

### Análisis de dependencias y composición

| Control | Implementación | Evidencia | Frecuencia |
|---------|----------------|-----------|------------|
| **SCA (Software Composition Analysis)** | OWASP Dependency Check + Snyk | SBOM generation, vulnerability reports | Por build |
| **License Compliance** | FOSSA + WhiteSource | License reports, compliance matrix | Mensual |
| **SBOM Generation** | CycloneDX format | SBOM documents, compliance evidence | Por release |

### Análisis de seguridad

| Control | Implementación | Evidencia | Frecuencia |
|---------|----------------|-----------|------------|
| **SAST (Static Analysis)** | SonarQube + Semgrep | Security hotspots, code quality gates | Por commit |
| **DAST (Dynamic Analysis)** | OWASP ZAP + Burp Suite | Vulnerability reports, false positive rate | Semanal |
| **IaC Scanning** | Checkov + Terrascan | Infrastructure vulnerabilities | Por deploy |
| **Container Scanning** | Trivy + Clair | Image vulnerabilities, blocking deploys | Por build |

### Control de versiones y supply chain

| Control | Implementación | Evidencia | Frecuencia |
|---------|----------------|-----------|------------|
| **Branch Protection** | Required reviews, status checks | PR policies, merge logs | Continuo |
| **Code Signing** | GPG signing de commits/tags | Signature verification, trust chain | Continuo |
| **Artifact Signing** | Cosign para containers | Signature verification, immutability | Por release |
| **Supply Chain Security** | SLSA framework compliance | Provenance verification, compliance reports | Por release |

### Puertas de calidad

| Control | Implementación | Threshold | Acción |
|---------|----------------|-----------|---------|
| **Security Gates** | CVSS >= 7.0 requiere excepción | Vulnerability assessment, risk acceptance | Por vulnerability |
| **Code Coverage** | 80% mínimo con tests de seguridad | Coverage reports, security test results | Por PR |
| **Dependency Updates** | Vulnerabilidades críticas en 48h | Automated updates, security patches | Continua |
| **Container Policies** | No privileged containers, resource limits | Runtime policies, violation alerts | Continuo |

## 6. Monitoreo y respuesta a incidentes

### Detección y alertas

| Use Case | Detección | Alerta | Severidad | MTTD Target |
|----------|-----------|--------|-----------|-------------|
| **Brute Force Attacks** | Failed login rate > 10/min por IP | Slack + PagerDuty | High | 5 min |
| **Privilege Escalation** | Acceso a recursos no autorizados | PagerDuty + Email | Critical | 2 min |
| **Data Exfiltration** | Anomalous data transfer > 100MB | PagerDuty + Security Team | Critical | 1 min |
| **API Abuse** | Rate limit violations > 1000/min | Slack + Monitoring | Medium | 15 min |
| **Configuration Changes** | Cambios no autorizados en IAM/policies | Email + Audit Log | High | 10 min |

### Playbooks de respuesta

| Tipo de Incidente | Playbook | MTTR Target | Propietario | Evidencia |
|------------------|----------|-------------|-------------|----------|
| **Data Breach** | Containment → Investigation → Notification → Recovery | 4 horas | CISO | Incident report, notification logs |
| **DDoS Attack** | Traffic diversion → Mitigation → Post-mortem | 30 min | Infra Team | Attack logs, mitigation effectiveness |
| **Credential Compromise** | Account lockdown → Password reset → MFA enforcement | 15 min | Security Team | Reset logs, access revocation |
| **Malware Infection** | Isolation → Forensic analysis → Cleanup → Prevention | 2 horas | Security Team | Forensic report, system restoration |
| **Misconfiguration** | Rollback → Access review → Policy update | 1 hora | DevOps Team | Configuration audit, remediation logs |

### Evidencias forenses

| Tipo de Evidencia | Retención | Almacenamiento | Acceso |
|------------------|-----------|---------------|---------|
| **Application Logs** | 90 días | Elasticsearch + S3 (encrypted) | Security Team + Auditors |
| **Security Events** | 7 años | SIEM + WORM storage | Compliance Officer |
| **Audit Trails** | 10 años | Immutable ledger + blockchain | Legal Department |
| **Network Traffic** | 30 días | Packet capture + encrypted storage | Forensics Team |
| **Database Changes** | 1 año | Change data capture + audit logs | DBA + Security Team |

## 7. Pruebas de seguridad

### Plan anual de pruebas

| Tipo de Prueba | Frecuencia | Alcance | Herramienta | Responsable |
|----------------|------------|---------|------------|-------------|
| **SAST** | Por commit | Todo el código | SonarQube + Semgrep | Dev Team |
| **DAST** | Semanal | APIs y UI | OWASP ZAP + Burp Suite | Security Team |
| **SCA** | Por build | Dependencias | Snyk + OWASP Dep Check | DevOps Team |
| **Container Security** | Por build | Imágenes | Trivy + Clair | DevOps Team |
| **Infrastructure Scan** | Semanal | IaC y configs | Checkov + Terrascan | Infra Team |
| **Pentest Caja Gris** | Trimestral | Aplicación completa | Ethical hackers externos | External Firm |
| **ASV (PCI)** | Anual | Infraestructura | Qualified Security Assessor | QSA Firm |

### Criterios de aceptación BDD

- *Dado* un usuario sin permisos de administrador, *cuando* intenta acceder al endpoint `/api/users/admin`, *entonces* recibe 403 Forbidden y se registra el intento en audit logs
- *Dado* un payload con script XSS básico `<script>alert(1)</script>`, *cuando* se renderiza en la UI, *entonces* no ejecuta el script y se loguea el intento de XSS
- *Dado* un ataque de inyección SQL en parámetro de búsqueda, *cuando* se ejecuta la query, *entonces* no se modifica el resultado esperado y se alerta al equipo de seguridad
- *Dado* credenciales válidas comprometidas, *cuando* se intenta login desde IP sospechosa, *entonces* se requiere MFA adicional y se notifica al usuario
- *Dado* un archivo malicioso subido al sistema, *cuando* se procesa, *entonces* se detecta por antivirus y se bloquea el upload con log de seguridad

### Dataset de pruebas

| Tipo de Test | Dataset | Anonimización | Propósito |
|--------------|---------|---------------|-----------|
| **Authentication Tests** | 1000 usuarios sintéticos | Hash + salt | Test de fuerza bruta y rate limiting |
| **Authorization Tests** | Matriz de permisos completa | Role-based | Test de privilege escalation |
| **Data Exposure Tests** | Datos sensibles sample | Tokenización | Test de information disclosure |
| **Injection Tests** | Payloads OWASP | Sanitización | Test de SQL/XSS/command injection |
| **File Upload Tests** | Archivos maliciosos | Sandbox | Test de malware y validation bypass |

## 8. Trazabilidad y excepciones

### Control ↔ Activo/Épica ↔ Evidencia/Prueba

| Control | Activo Protegido | Épica | Evidencia | Prueba |
|---------|------------------|-------|-----------|--------|
| **Autenticación MFA** | Credenciales de usuario | EP-001 (acceso interno), EP-004/019 (portal cliente) | Logs de MFA, compliance reports | Penetration testing |
| **Cifrado de datos sensibles** | Registros de tiempo, presupuestos | EP-012, EP-006 a EP-008 | Certificados de cifrado, KMS logs | Encryption validation tests |
| **RBAC Authorization** | Permisos de proyecto y aprobaciones | EP-006, EP-007, EP-010 | Audit logs, access matrices | Authorization unit tests |
| **API Rate Limiting** | Endpoints críticos | EP-006, EP-019 | Rate limit logs, throttling metrics | Load testing scenarios |
| **Input Validation** | Formularios y APIs | Todas las épicas | Validation logs, error responses | DAST scanning |
| **Secret Management** | API keys, DB passwords | Infraestructura | Vault access logs, rotation reports | Secret scanning CI/CD |

### Registro de excepciones de seguridad

| ID Excepción | Control | Justificación | Riesgo Aceptado | Fecha Expiración | Aprobado Por |
|--------------|---------|----------------|-----------------|------------------|--------------|
| **SEC-001** | MFA temporal | Usuarios legacy sin smartphone | Bajo riesgo de compromiso | 2025-06-01 | CISO |
| **SEC-002** | Cifrado reducido | Performance crítica en reportes | Datos agregados no sensibles | 2025-03-01 | CTO |
| **SEC-003** | Access logging reducido | Alto volumen de requests | Eventos de bajo riesgo | 2025-12-01 | Security Lead |
| **SEC-004** | Third-party integration | Discord API limitations | Datos públicos de mensajes | 2025-09-01 | Product Owner |

## 9. Riesgos y TODOs

### Riesgos críticos de seguridad

| Riesgo | Probabilidad | Impacto | Mitigación | Propietario |
|--------|--------------|---------|------------|-------------|
| **Third-party breach (Discord)** | Media | Alto | mTLS, data minimization, monitoring | Security Team |
| **Insider threat** | Baja | Alto | RBAC estricto, audit logging, background checks | HR + Security |
| **Supply chain attack** | Media | Alto | SBOM, signed artifacts, dependency scanning | DevSecOps Team |
| **Configuration drift** | Alta | Medio | IaC, automated scanning, change management | Infra Team |
| **Data exfiltration** | Media | Alto | DLP, network monitoring, encryption | Security Team |
| **API abuse** | Alta | Medio | Rate limiting, API gateways, monitoring | Dev Team |

### TODOs de seguridad

#### TODO: Implementar baseline de seguridad
- **Descripción**: Establecer controles básicos de autenticación, autorización y cifrado
- **Dueño**: Security Team
- **Fecha objetivo**: Q4 2024
- **Dependencias**: Arquitectura base implementada

#### TODO: Configurar SIEM y monitoreo
- **Descripción**: Implementar sistema de detección y respuesta a incidentes
- **Dueño**: Security Team
- **Fecha objetivo**: Q4 2024
- **Dependencias**: Infraestructura de logging lista

#### TODO: Establecer programa de pentesting
- **Descripción**: Contratar firma externa para pruebas de penetración iniciales
- **Dueño**: CISO
- **Fecha objetivo**: Q1 2025
- **Dependencias**: Sistema en staging funcional

#### TODO: Implementar DevSecOps pipeline
- **Descripción**: Integrar SAST, DAST y SCA en CI/CD pipeline
- **Dueño**: DevSecOps Team
- **Fecha objetivo**: Q4 2024
- **Dependencias**: Pipeline CI/CD base implementado

#### TODO: Capacitación de seguridad
- **Descripción**: Programa de training en security awareness para todo el equipo
- **Dueño**: Security Team
- **Fecha objetivo**: Q4 2024
- **Dependencias**: Equipo completo contratado

#### TODO: Certificación de cumplimiento
- **Descripción**: Obtener certificaciones SOC 2 Type II e ISO 27001
- **Dueño**: Compliance Officer
- **Fecha objetivo**: Q2 2025
- **Dependencias**: Controles de seguridad implementados

---

## Trazabilidad (fuentes)

### Functional requirements (ONGAKU EP-001 a EP-027):
- EP-001: captación automática de leads (formulario, contactos)
- EP-004: agendamiento reuniones (calendario, integración)
- EP-005: registro información reunión (datos para presupuesto)
- EP-006 a EP-009: presupuestos, contratos, firmas digitales
- EP-012, EP-013: registro tiempo y recursos (datos sensibles)
- EP-016 a EP-018: día boda, postproducción, material RRSS (Discord si aplica)
- EP-019 a EP-021: entrega material, comentarios, segunda entrega
- EP-025 a EP-027: almacenamiento archivos, ubicación discos, retención/eliminación

Ruta: `02-discovery/0202-prd/020205-functional-requirements/`

### TO-BE procesos:
- Procesos TO-BE-001 a TO-BE-027 en `02-discovery/0202-prd/020203-to-be/processes/`

### Compliance requirements:
- `020206-non-functional-requirements/compliance/compliance.md` (clasificación de datos, GDPR/LOPDGDD, SOC 2)

### Scope diagrams:
- `02-discovery/0202-prd/020204-scope/`

---

*Documento alineado con EPICS-INDEX de ONGAKU. Revisado y aprobado por Arquitecto de Seguridad y CISO.*
