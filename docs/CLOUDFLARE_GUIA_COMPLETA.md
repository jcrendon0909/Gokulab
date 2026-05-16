# 🚀 GUÍA COMPLETA - GOKULAB EN CLOUDFLARE

## Tabla de Contenidos
1. [Arquitectura General](#arquitectura-general)
2. [Fase 1: Preparación](#fase-1-preparación)
3. [Fase 2: Backend](#fase-2-backend)
4. [Fase 3: Frontend](#fase-3-frontend)
5. [Fase 4: Deployment](#fase-4-deployment)
6. [Referencias](#referencias)

---

# ARQUITECTURA GENERAL

## 🏗️ Stack Cloudflare

```
┌─────────────────────────────────────────────────────────────┐
│                   🌐 INTERNET / USUARIOS                     │
└────────────────────────────┬────────────────────────────────┘
                             │
                             ▼
        ┌────────────────────────────────────────┐
        │   🔒 CLOUDFLARE GLOBAL NETWORK         │
        │   (DDoS Protection, Caching, WAF)      │
        └────────────────────┬───────────────────┘
                             │
        ┌────────────────────┴──────────────────┐
        ▼                                        ▼
  ┌──────────────┐                      ┌──────────────┐
  │ PAGES        │                      │ WORKERS      │
  │(Frontend)    │                      │(API Backend) │
  │              │                      │              │
  │✅ Website    │  HTTP/HTTPS          │✅ Auth       │
  │✅ Chatbot    │◄─────────────────►   │✅ Forms      │
  │   Link       │  JSON REST           │✅ Surveys    │
  │✅ Responsive │                      │✅ Payments   │
  └──────────────┘                      └──────┬───────┘
                                               │
                ┌──────────────────────────────┼──────────────────────┐
                ▼                              ▼                      ▼
           ┌────────┐                    ┌──────────┐           ┌────────┐
           │  D1    │                    │   KV     │           │  R2    │
           │(SQLite)│                    │(Key-Val) │           │Storage │
           │        │                    │          │           │        │
           │✅ Users│                    │✅ Cache  │           │✅ Fotos│
           │✅ Forms│                    │✅ Sessions          │✅ Assets
           │✅ Surveys                  │✅ Tokens │           └────────┘
           │✅ Bookings                 └──────────┘
           └────────┘
```

---

## 🔗 Flujos de Datos

### 1. Usuario envía Formulario
```
Website (React)
    ↓
  POST /api/forms
    ↓
Cloudflare Workers
    ↓
  Valida datos
    ↓
  D1 Database
    ↓
  Respuesta JSON
    ↓
Website actualiza UI
```

### 2. Upload Foto
```
Website
    ↓
  POST /api/upload (FormData)
    ↓
Cloudflare Workers
    ↓
  Valida archivo
    ↓
  R2 Storage
    ↓
  Retorna URL pública
    ↓
Website muestra imagen
```

### 3. Acceso Chatbot
```
Website
    ↓
  Click en Link/Display
    ↓
  Abre Iframe o ventana
    ↓
  Chatbot externo (corre por separado)
    ↓
  Conversación independiente
```

---

# FASE 1: PREPARACIÓN

## 1.1 Prerequisitos

### Instalar herramientas
```bash
# Node.js y npm (ya deberías tenerlo)
node --version  # v18+
npm --version   # 10+

# Instalar Wrangler (CLI de Cloudflare)
npm install -g wrangler@latest

# Verificar instalación
wrangler --version
```

### Cuenta Cloudflare
1. Ve a https://dash.cloudflare.com
2. Si no tienes cuenta, créala (gratis)
3. Agrega tu dominio o usa el subdominio gratis de Cloudflare

---

## 1.2 Autenticación en Cloudflare

```bash
# Login en Cloudflare
wrangler login

# Se abrirá el navegador, autoriza la aplicación
# Verás: "✅ Successfully authenticated!"
```

---

## 1.3 Crear proyecto Workers

```bash
# Dentro del repositorio central
cd Gokulab

# Crear proyecto Workers
wrangler init gokulab-api

# Responde las preguntas:
# - Nombre: gokulab-api
# - ¿Usar TypeScript? Sí
# - ¿Criar test? Sí
# - Git: No (ya estamos en git)
```

---

## 1.4 Estructura de carpetas

```
Gokulab/
├── gokulab-api/
│   ├── src/
│   │   ├── index.ts (entry point)
│   │   ├── middleware/
│   │   │   ├── auth.ts
│   │   │   └── cors.ts
│   │   ├── routes/
│   │   │   ├── forms.ts
│   │   │   ├── surveys.ts
│   │   │   ├── upload.ts
│   │   │   ├── auth.ts
│   │   │   └── health.ts
│   │   ├── services/
│   │   │   ├── database.ts
│   │   │   ├── storage.ts
│   │   │   └── email.ts
│   │   └── types/
│   │       └── index.ts
│   ├── wrangler.toml (configuración)
│   ├── package.json
│   └── tsconfig.json
├── GokuLab_WebSite/
├── docs/
└── README.md
```

---

## 1.5 Configurar wrangler.toml

```toml
name = "gokulab-api"
main = "src/index.ts"
compatibility_date = "2024-05-16"

# Configurar D1 Database
[[d1_databases]]
binding = "DB"
database_name = "gokulab"
database_id = "YOUR_DB_ID" # Se genera después

# Configurar KV Store
[[kv_namespaces]]
binding = "KV"
id = "YOUR_KV_ID" # Se genera después

# Configurar R2 Bucket
[[r2_buckets]]
binding = "BUCKET"
bucket_name = "gokulab-media"

# Variables de entorno
[env.production]
route = "api.tu-dominio.com/api/*"
vars = { ENVIRONMENT = "production" }

[env.staging]
route = "staging-api.tu-dominio.com/api/*"
vars = { ENVIRONMENT = "staging" }

# Migrations (para D1)
migrations_dir = "migrations"
```

---

## 1.6 Crear D1 Database

```bash
# Crear base de datos
wrangler d1 create gokulab

# Output:
# ✅ Successfully created D1 database 'gokulab'
# 📝 Note: wrangler.toml configuration added!

# Copiar database_id y actualizar wrangler.toml
```

---

## 1.7 Crear KV Namespace

```bash
# Crear KV store
wrangler kv:namespace create gokulab

# Output:
# ✅ Created namespace with id: YOUR_KV_ID

# Copiar id y actualizar wrangler.toml
```

---

## 1.8 Crear R2 Bucket

```bash
# Crear bucket R2
wrangler r2 bucket create gokulab-media

# Output:
# ✅ Successfully created the r2 bucket 'gokulab-media'
```

---

## 1.9 Conectar GitHub para CI/CD

1. Ve a **Cloudflare Dashboard** → **Pages**
2. Click en "Create a project"
3. Selecciona "Connect to Git"
4. Autoriza GitHub
5. Selecciona repositorio `Gokulab`
6. Configurar:
   - Framework: None (custom)
   - Build command: `npm install && npm run build`
   - Build output: `dist`

---

# FASE 2: BACKEND

## 2.1 Schema D1 Database

### Crear archivo de migración

```bash
wrangler d1 migrations create gokulab init_schema
```

### Archivo: `migrations/0001_init_schema.sql`

```sql
-- Tabla de Usuarios
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  name TEXT NOT NULL,
  phone TEXT,
  role TEXT DEFAULT 'student', -- student | admin | instructor
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Formularios (Dinámicos)
CREATE TABLE forms (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  fields JSON NOT NULL, -- [{name, type, required, ...}]
  created_by TEXT NOT NULL REFERENCES users(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(created_by) REFERENCES users(id)
);

-- Tabla de Respuestas de Formularios
CREATE TABLE form_responses (
  id TEXT PRIMARY KEY,
  form_id TEXT NOT NULL REFERENCES forms(id),
  user_id TEXT,
  email TEXT,
  data JSON NOT NULL, -- {field_name: value}
  ip_address TEXT,
  user_agent TEXT,
  submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(form_id) REFERENCES forms(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

-- Tabla de Encuestas
CREATE TABLE surveys (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  questions JSON NOT NULL, -- [{question, type, options, ...}]
  created_by TEXT NOT NULL REFERENCES users(id),
  active BOOLEAN DEFAULT true,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(created_by) REFERENCES users(id)
);

-- Tabla de Respuestas de Encuestas
CREATE TABLE survey_responses (
  id TEXT PRIMARY KEY,
  survey_id TEXT NOT NULL REFERENCES surveys(id),
  user_id TEXT,
  email TEXT,
  answers JSON NOT NULL, -- {question_id: answer}
  submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(survey_id) REFERENCES surveys(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

-- Tabla de Cursos
CREATE TABLE courses (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price REAL,
  image_url TEXT,
  instructor_id TEXT NOT NULL REFERENCES users(id),
  capacity INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(instructor_id) REFERENCES users(id)
);

-- Tabla de Reservas
CREATE TABLE bookings (
  id TEXT PRIMARY KEY,
  course_id TEXT NOT NULL REFERENCES courses(id),
  user_id TEXT,
  email TEXT NOT NULL,
  status TEXT DEFAULT 'pending', -- pending | confirmed | cancelled | completed
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(course_id) REFERENCES courses(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

-- Tabla de Media (Fotos)
CREATE TABLE media (
  id TEXT PRIMARY KEY,
  filename TEXT NOT NULL,
  r2_url TEXT NOT NULL,
  uploaded_by TEXT NOT NULL REFERENCES users(id),
  alt_text TEXT,
  size INTEGER,
  mime_type TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(uploaded_by) REFERENCES users(id)
);

-- Índices para performance
CREATE INDEX idx_forms_created_by ON forms(created_by);
CREATE INDEX idx_form_responses_form_id ON form_responses(form_id);
CREATE INDEX idx_form_responses_user_id ON form_responses(user_id);
CREATE INDEX idx_surveys_created_by ON surveys(created_by);
CREATE INDEX idx_survey_responses_survey_id ON survey_responses(survey_id);
CREATE INDEX idx_bookings_course_id ON bookings(course_id);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_media_uploaded_by ON media(uploaded_by);
```

### Ejecutar migración

```bash
wrangler d1 migrations apply gokulab
```

---

## 2.2 Tipos TypeScript

### Archivo: `src/types/index.ts`

```typescript
// Usuario
export interface User {
  id: string;
  email: string;
  name: string;
  phone?: string;
  role: 'student' | 'admin' | 'instructor';
  created_at: string;
  updated_at: string;
}

// Formulario
export interface Form {
  id: string;
  name: string;
  description?: string;
  fields: FormField[];
  created_by: string;
  created_at: string;
}

export interface FormField {
  name: string;
  label: string;
  type: 'text' | 'email' | 'number' | 'textarea' | 'select' | 'checkbox';
  required: boolean;
  options?: string[];
}

export interface FormResponse {
  id: string;
  form_id: string;
  user_id?: string;
  email?: string;
  data: Record<string, any>;
  ip_address: string;
  user_agent: string;
  submitted_at: string;
}

// Encuesta
export interface Survey {
  id: string;
  title: string;
  description?: string;
  questions: SurveyQuestion[];
  created_by: string;
  active: boolean;
  created_at: string;
}

export interface SurveyQuestion {
  id: string;
  question: string;
  type: 'multiple_choice' | 'short_text' | 'long_text' | 'rating';
  options?: string[];
}

export interface SurveyResponse {
  id: string;
  survey_id: string;
  user_id?: string;
  email?: string;
  answers: Record<string, any>;
  submitted_at: string;
}

// Media
export interface Media {
  id: string;
  filename: string;
  r2_url: string;
  uploaded_by: string;
  alt_text?: string;
  size: number;
  mime_type: string;
  created_at: string;
}

// API Response
export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}
```

---

## 2.3 Middleware

### Archivo: `src/middleware/cors.ts`

```typescript
export function handleCORS(request: Request): Response | null {
  const origin = request.headers.get('origin');
  const allowedOrigins = [
    'http://localhost:3000',
    'https://gokulab.vercel.app',
    'https://tu-dominio.com'
  ];

  const isAllowed = allowedOrigins.includes(origin || '');

  if (request.method === 'OPTIONS') {
    return new Response(null, {
      status: 204,
      headers: {
        'Access-Control-Allow-Origin': isAllowed ? origin || '*' : '',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Access-Control-Max-Age': '86400',
      },
    });
  }

  return null;
}

export function addCORSHeaders(response: Response, origin: string | null): Response {
  const allowedOrigins = [
    'http://localhost:3000',
    'https://gokulab.vercel.app',
    'https://tu-dominio.com'
  ];

  const isAllowed = allowedOrigins.includes(origin || '');
  const newResponse = new Response(response.body, response);

  if (isAllowed) {
    newResponse.headers.set('Access-Control-Allow-Origin', origin || '*');
  }
  newResponse.headers.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  newResponse.headers.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  return newResponse;
}
```

### Archivo: `src/middleware/auth.ts`

```typescript
import { verify } from '@tsndr/cloudflare_workers_jwt';

const JWT_SECRET = 'your-secret-key'; // Usar variable de entorno

export async function validateToken(request: Request): Promise<{ user_id: string } | null> {
  const authHeader = request.headers.get('Authorization');
  if (!authHeader) return null;

  const token = authHeader.replace('Bearer ', '');

  try {
    const payload = await verify(token, JWT_SECRET);
    return { user_id: payload.user_id as string };
  } catch (error) {
    return null;
  }
}

export async function requireAuth(request: Request): Promise<Response | null> {
  const auth = await validateToken(request);
  if (!auth) {
    return new Response(
      JSON.stringify({ success: false, error: 'Unauthorized' }),
      { status: 401, headers: { 'Content-Type': 'application/json' } }
    );
  }
  return null;
}
```

---

## 2.4 Rutas API

### Archivo: `src/routes/forms.ts`

```typescript
import { ApiResponse, Form, FormResponse } from '../types';

interface Env {
  DB: D1Database;
  KV: KVNamespace;
}

// GET /api/forms - Lista formularios
export async function getForms(env: Env): Promise<Response> {
  try {
    const forms = await env.DB.prepare(
      'SELECT * FROM forms ORDER BY created_at DESC'
    ).all();

    const response: ApiResponse<Form[]> = {
      success: true,
      data: forms.results as Form[],
    };

    return new Response(JSON.stringify(response), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    return new Response(
      JSON.stringify({ success: false, error: 'Error fetching forms' }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
}

// POST /api/forms/:id/responses - Enviar respuesta
export async function submitFormResponse(
  env: Env,
  formId: string,
  body: any,
  request: Request
): Promise<Response> {
  try {
    const { email, data } = body;
    const ip = request.headers.get('cf-connecting-ip') || 'unknown';
    const userAgent = request.headers.get('user-agent') || '';

    const responseId = `resp_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;

    await env.DB.prepare(
      `INSERT INTO form_responses (id, form_id, email, data, ip_address, user_agent)
       VALUES (?, ?, ?, ?, ?, ?)`
    ).bind(responseId, formId, email, JSON.stringify(data), ip, userAgent).run();

    return new Response(
      JSON.stringify({ success: true, data: { id: responseId } }),
      { status: 201, headers: { 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ success: false, error: 'Error submitting form' }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
}
```

---

## 2.5 Archivo Principal

### Archivo: `src/index.ts`

```typescript
import { Router } from 'itty-router';
import { handleCORS, addCORSHeaders } from './middleware/cors';
import { requireAuth } from './middleware/auth';
import * as formsRoutes from './routes/forms';

interface Env {
  DB: D1Database;
  KV: KVNamespace;
  BUCKET: R2Bucket;
}

const router = Router();

// Health check
router.get('/api/health', () => new Response('OK', { status: 200 }));

// CORS preflight
router.options('*', (request) => handleCORS(request) || new Response(null, { status: 204 }));

// Rutas de formularios
router.get('/api/forms', (request, env: Env) => formsRoutes.getForms(env));
router.post('/api/forms/:id/responses', async (request, env: Env) => {
  const body = await request.json();
  return formsRoutes.submitFormResponse(env, request.params.id, body, request);
});

// 404
router.all('*', () => new Response('Not Found', { status: 404 }));

// Export handler
export default {
  fetch: async (request: Request, env: Env, ctx: ExecutionContext) => {
    const corsCheck = handleCORS(request);
    if (corsCheck) return corsCheck;

    const response = await router.handle(request, env, ctx);
    const origin = request.headers.get('origin');
    
    return addCORSHeaders(response, origin);
  },
};
```

---

## 2.6 Package.json

```json
{
  "name": "gokulab-api",
  "version": "1.0.0",
  "description": "Gokulab Backend API",
  "main": "src/index.ts",
  "scripts": {
    "dev": "wrangler dev",
    "deploy": "wrangler deploy",
    "build": "wrangler build",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "itty-router": "^4.1.8",
    "@tsndr/cloudflare_workers_jwt": "^3.3.2"
  },
  "devDependencies": {
    "wrangler": "^3.0.0",
    "typescript": "^5.0.0",
    "@cloudflare/workers-types": "^4.0.0"
  }
}
```

---

# FASE 3: FRONTEND

## 3.1 Integrar API en Website

### Crear hook: `src/app/hooks/useApi.ts`

```typescript
import { useState, useCallback } from 'react';

const API_BASE_URL = process.env.VITE_API_URL || 'http://localhost:8787/api';

export function useApi() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const request = useCallback(async (
    endpoint: string,
    method: 'GET' | 'POST' | 'PUT' | 'DELETE' = 'GET',
    data?: any
  ) => {
    try {
      setLoading(true);
      setError(null);

      const options: RequestInit = {
        method,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${localStorage.getItem('token') || ''}`,
        },
      };

      if (data) {
        options.body = JSON.stringify(data);
      }

      const response = await fetch(`${API_BASE_URL}${endpoint}`, options);

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }

      return await response.json();
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Error';
      setError(message);
      throw err;
    } finally {
      setLoading(false);
    }
  }, []);

  return { request, loading, error };
}
```

### Crear Componente: `src/app/components/FormSubmit.tsx`

```typescript
import { useState } from 'react';
import { useApi } from '../hooks/useApi';

interface FormSubmitProps {
  formId: string;
  onSuccess?: () => void;
}

export function FormSubmit({ formId, onSuccess }: FormSubmitProps) {
  const { request, loading, error } = useApi();
  const [formData, setFormData] = useState({ email: '' });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
      await request(`/forms/${formId}/responses`, 'POST', formData);
      setFormData({ email: '' });
      onSuccess?.();
    } catch (err) {
      console.error('Error:', err);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="email"
        value={formData.email}
        onChange={(e) => setFormData({ ...formData, email: e.target.value })}
        required
      />
      <button type="submit" disabled={loading}>
        {loading ? 'Enviando...' : 'Enviar'}
      </button>
      {error && <p style={{ color: 'red' }}>{error}</p>}
    </form>
  );
}
```

---

## 3.2 Integrar Chatbot

### Crear Componente: `src/app/components/ChatbotWidget.tsx`

```typescript
import { useState } from 'react';
import { MessageCircle, X } from 'lucide-react';

export function ChatbotWidget() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <>
      {/* Botón flotante */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="fixed bottom-6 right-6 w-14 h-14 rounded-full bg-gradient-to-r from-cyan-400 to-purple-500 text-white shadow-lg hover:shadow-xl transition-all"
        aria-label="Abrir chatbot"
      >
        {isOpen ? <X size={24} /> : <MessageCircle size={24} />}
      </button>

      {/* Chatbot Iframe / Widget */}
      {isOpen && (
        <div className="fixed bottom-24 right-6 w-96 h-96 rounded-lg shadow-2xl bg-white overflow-hidden">
          <iframe
            src="https://tu-chatbot-url.com" // URL de tu chatbot externo
            title="Gokulab Chatbot"
            className="w-full h-full border-none"
          />
        </div>
      )}
    </>
  );
}
```

### Integrar en Layout: `src/app/Layout.tsx`

```typescript
import { ChatbotWidget } from './components/ChatbotWidget';

export function Layout({ children }: { children: React.ReactNode }) {
  return (
    <>
      {children}
      <ChatbotWidget />
    </>
  );
}
```

---

## 3.3 Upload de Fotos a R2

### Crear Componente: `src/app/components/PhotoUpload.tsx`

```typescript
import { useState } from 'react';
import { useApi } from '../hooks/useApi';
import { Upload } from 'lucide-react';

export function PhotoUpload() {
  const { request, loading } = useApi();
  const [preview, setPreview] = useState<string | null>(null);

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    // Preview
    const reader = new FileReader();
    reader.onload = (e) => setPreview(e.target?.result as string);
    reader.readAsDataURL(file);

    // Upload
    try {
      const formData = new FormData();
      formData.append('file', file);
      formData.append('alt_text', 'Foto de Gokulab');

      // Usar fetch directamente para FormData
      const response = await fetch(`${process.env.VITE_API_URL}/upload`, {
        method: 'POST',
        body: formData,
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('token') || ''}`,
        },
      });

      if (!response.ok) throw new Error('Upload failed');

      const data = await response.json();
      console.log('Foto subida:', data.url);
    } catch (error) {
      console.error('Error uploading:', error);
    }
  };

  return (
    <div className="flex flex-col items-center gap-4">
      <label className="flex flex-col items-center justify-center w-32 h-32 border-2 border-dashed rounded-lg cursor-pointer hover:bg-gray-50">
        <Upload size={24} />
        <span className="text-sm">Subir Foto</span>
        <input
          type="file"
          accept="image/*"
          onChange={handleFileChange}
          disabled={loading}
          className="hidden"
        />
      </label>
      {preview && <img src={preview} alt="preview" className="w-32 h-32 object-cover rounded" />}
    </div>
  );
}
```

---

# FASE 4: DEPLOYMENT

## 4.1 Deploy Backend

```bash
# Desde la carpeta gokulab-api
cd gokulab-api

# Deploy a producción
wrangler deploy --env production

# Verificar
curl https://api.tu-dominio.com/api/health
```

---

## 4.2 Deploy Frontend

```bash
# Desde GokuLab_WebSite
cd GokuLab_WebSite

# Build
npm run build

# Deploy automático con Cloudflare Pages
# (Se hace automático al hacer push a main en GitHub)
```

---

## 4.3 Monitoreo

### Cloudflare Dashboard
1. Ve a **Analytics & Logs**
2. Monitorea:
   - Requests
   - Errors
   - Performance

### Logs de Workers
```bash
wrangler tail gokulab-api
```

---

# REFERENCIAS

- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [D1 Database](https://developers.cloudflare.com/d1/)
- [R2 Storage](https://developers.cloudflare.com/r2/)
- [KV Store](https://developers.cloudflare.com/kv/)
- [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/)

---

**Última actualización:** 16 de Mayo, 2026
**Versión:** 1.0.0
