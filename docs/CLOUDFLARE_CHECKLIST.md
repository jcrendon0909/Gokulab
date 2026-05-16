# 🎯 Checklist - Implementación Cloudflare

## FASE 1: PREPARACIÓN

### Requisitos
- [ ] Node.js 18+ instalado
- [ ] npm 10+ instalado
- [ ] Cuenta Cloudflare creada
- [ ] Git instalado

### Setup Inicial
- [ ] Instalar Wrangler: `npm install -g wrangler@latest`
- [ ] Login: `wrangler login`
- [ ] Crear Workers project: `wrangler init gokulab-api`
- [ ] Crear D1 database: `wrangler d1 create gokulab`
- [ ] Crear KV namespace: `wrangler kv:namespace create gokulab`
- [ ] Crear R2 bucket: `wrangler r2 bucket create gokulab-media`
- [ ] Actualizar `wrangler.toml` con IDs
- [ ] Conectar GitHub para CI/CD en Cloudflare Pages

---

## FASE 2: BACKEND

### Database
- [ ] Crear archivo de migración SQL
- [ ] Ejecutar migraciones: `wrangler d1 migrations apply gokulab`
- [ ] Verificar schema: `wrangler d1 query gokulab "SELECT name FROM sqlite_master WHERE type='table'"`

### Code Structure
- [ ] Crear carpeta `src/types`
- [ ] Crear `src/types/index.ts` con interfaces
- [ ] Crear `src/middleware/cors.ts`
- [ ] Crear `src/middleware/auth.ts`
- [ ] Crear `src/routes/forms.ts`
- [ ] Crear `src/routes/surveys.ts`
- [ ] Crear `src/routes/upload.ts`
- [ ] Crear `src/services/database.ts`
- [ ] Crear `src/services/storage.ts`

### Main Worker
- [ ] Crear `src/index.ts` (entry point)
- [ ] Setup router
- [ ] Configurar middleware (CORS, Auth)
- [ ] Agregar rutas

### Dependencies
- [ ] `npm install itty-router`
- [ ] `npm install @tsndr/cloudflare_workers_jwt`
- [ ] `npm install -D wrangler typescript`

### Testing Local
- [ ] `wrangler dev` (ejecutar localmente)
- [ ] Probar endpoints con curl o Postman
- [ ] Verificar D1 local

---

## FASE 3: FRONTEND

### Setup Website
- [ ] Agregar variable `VITE_API_URL` en `.env`
- [ ] Crear `src/app/hooks/useApi.ts`
- [ ] Crear componente `FormSubmit.tsx`
- [ ] Crear componente `PhotoUpload.tsx`
- [ ] Crear componente `ChatbotWidget.tsx`
- [ ] Integrar `ChatbotWidget` en Layout

### Testing
- [ ] `npm run dev` (ejecutar website)
- [ ] Probar envío de formularios
- [ ] Probar upload de fotos
- [ ] Probar widget chatbot
- [ ] Verificar CORS

### Build
- [ ] `npm run build`
- [ ] Verificar carpeta `dist`

---

## FASE 4: DEPLOYMENT

### Backend
- [ ] Configurar variables de producción en wrangler.toml
- [ ] `wrangler deploy --env production`
- [ ] Verificar deployment: `curl https://api.tu-dominio.com/api/health`
- [ ] Revisar logs: `wrangler tail gokulab-api`

### Frontend
- [ ] Hacer push a GitHub
- [ ] Verificar que Cloudflare Pages construye automáticamente
- [ ] Verificar que el sitio está en línea
- [ ] Probar endpoints en producción

### Monitoreo
- [ ] Configurar alertas en Cloudflare
- [ ] Revisar Analytics
- [ ] Configurar Email de errores

---

## VERIFICACIONES FINALES

### Backend
- [ ] GET /api/health → 200 OK
- [ ] POST /api/forms/:id/responses → 201 Created
- [ ] Upload de archivos a R2
- [ ] CORS headers correctos
- [ ] Errores manejados correctamente

### Frontend
- [ ] Website carga correctamente
- [ ] Formularios envían datos
- [ ] Fotos se suben y se muestran
- [ ] Chatbot widget visible
- [ ] Responsive en móvil
- [ ] Dark mode funciona
- [ ] Multiidioma funciona

### Performance
- [ ] Lighthouse score > 90
- [ ] API response < 200ms
- [ ] Fotos optimizadas

---

**Estado:** [ ] Incompleto | [x] En Progreso | [ ] Completado
