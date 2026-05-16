# 🔧 Stack Tecnológico - GŌKU LAB

## Frontend (Website)

### Lenguaje
- **TypeScript 5+:** Type-safe JavaScript
- **ECMAScript 2023+:** Modern JavaScript features

### Framework y Build
- **React 18.3.1:** UI library
- **Vite 6.3.5:** Next-generation build tool
  - ⚡ Hot Module Replacement (HMR)
  - 🚀 Ultra-rápido en desarrollo
  - 📦 Excelentes outputs para producción

### Styling
- **Tailwind CSS 4.1.12:** Utility-first CSS framework
  - 🎨 Temas customizables
  - 🌙 Soporte dark mode nativo
  - 📱 Mobile-first responsive design
- **PostCSS 8:** CSS transformations

### Componentes y UI
- **shadcn/ui:** Componentes sin dependencias
  - Componentes Radix UI + Tailwind
  - Copiable y customizable
  - Componentes incluidos:
    - Accordion
    - Alert Dialog
    - Checkbox, Radio, Select
    - Dialog, Dropdown
    - Tabs, Toggle
    - Y muchos más...
- **Lucide React 0.487:** Icon library
  - +500 iconos SVG
  - Consistentes y optimizados

### Enrutamiento
- **React Router 7.13:** Declarative routing
  - Client-side routing
  - Nested routes
  - Lazy loading

### Animaciones
- **Framer Motion 12.23.24:** Motion library
  - Animaciones fluidas
  - Gestos y interacciones
  - Spring physics

### Estado y Context
- **React Context API:** State management (built-in)
  - LanguageContext (multiidioma)
  - ThemeContext (dark/light mode)
- **next-themes 0.4.6:** Theme management
  - Persistence automática
  - SSR compatible

### Formularios
- **React Hook Form 7.55:** Efficient form handling
  - Validation integrada
  - Performance optimizado
- **Input OTP 1.4.2:** OTP input component

### Datos y Comunicación
- **Recharts 2.15.2:** React charts library
  - Gráficos interactivos
  - Responsive
- **Sonner 2.0.3:** Toast notifications

### Utilities
- **clsx 2.1.1:** Conditional className utility
- **tailwind-merge 3.2.0:** Merge Tailwind classes
- **class-variance-authority 0.7.1:** Component variants
- **cmdk 1.1.1:** Command/search component
- **date-fns 3.6:** Date utilities
- **canvas-confetti 1.9.4:** Confetti effects

### Carruseles y Drag/Drop
- **Embla Carousel React 8.6:** Carousel component
- **React DnD 16.0.1:** Drag and drop
  - react-dnd-html5-backend
- **React Slick 0.31:** Slider component
- **React Resizable Panels 2.1.7:** Resizable panels

### Otros
- **Motion 12.23.24:** Animation library alternative
- **react-responsive-masonry 2.7.1:** Masonry layout
- **vaul 1.1.2:** Drawer/swipe component
- **react-popper 2.3.0:** Tooltip/popover positioning
- **Material UI Icons 7.3.5:** Icon set (backup)
- **Material UI 7.3.5:** Component library (backup)
- **Emotion:** CSS-in-JS (para MUI)

---

## Backend (Recomendación para Próximos)

### Opción A: Node.js (Recomendado)
- **Runtime:** Node.js 18+
- **Framework:** Express.js o Fastify
- **Database:** PostgreSQL + Prisma ORM
- **Cache:** Redis
- **Authentication:** JWT + Passport.js
- **API Documentation:** Swagger/OpenAPI
- **Testing:** Jest + Supertest
- **Logging:** Winston o Pino

### Opción B: Python
- **Framework:** FastAPI o Django
- **ORM:** SQLAlchemy
- **Database:** PostgreSQL
- **Cache:** Redis
- **API:** FastAPI (async-first)

---

## Base de Datos

- **Primaria:** PostgreSQL 14+
  - Relacional
  - JSONB support
  - Full-text search
- **Cache:** Redis 7+
  - Session storage
  - Rate limiting
  - Real-time data
- **Search:** Elasticsearch (opcional)
  - Full-text search avanzado
  - Análisis

---

## DevOps y Deployment

### Versionado
- **Git:** GitHub
- **Branching:** Git Flow
- **Commits:** Conventional Commits

### CI/CD
- **GitHub Actions:** Automation
  - Tests en cada PR
  - Build y deploy automático
  - Linting

### Hosting
- **Frontend:** Vercel (recomendado) o Netlify
- **Backend:** AWS (EC2/ECS), Heroku, o Railway
- **Database:** AWS RDS o Railway
- **Storage:** AWS S3 o similar

### Containerización
- **Docker:** Container runtime
- **Docker Compose:** Local development
- **Kubernetes:** Orquestación (futuro)

---

## Monitoreo y Análisis

### Analytics
- **Google Analytics 4:** User behavior
- **Mixpanel:** Product analytics (opcional)
- **Meta Pixel:** Conversion tracking

### Error Tracking
- **Sentry:** Error and performance monitoring

### Logs
- **ELK Stack:** Elasticsearch + Logstash + Kibana
- **Datadog:** APM y monitoring

### Performance
- **Lighthouse:** Performance audits
- **WebVitals:** Core Web Vitals tracking

---

## Seguridad

### Certificados
- **SSL/TLS:** HTTPS everywhere
- **Let's Encrypt:** Free certificates

### Autenticación
- **JWT:** JSON Web Tokens
- **OAuth 2.0:** Social login (Google, GitHub)
- **2FA:** Two-factor authentication

### Validación
- **Helmet.js:** Security headers
- **CORS:** Cross-Origin Resource Sharing
- **CSRF Protection:** Anti CSRF tokens

---

## Dependencias en package.json (Website)

### Production Dependencies
```json
{
  "react": "18.3.1",
  "react-dom": "18.3.1",
  "react-router": "7.13.0",
  "vite": "6.3.5",
  "tailwindcss": "4.1.12",
  "next-themes": "0.4.6",
  "framer-motion": "12.23.24",
  "lucide-react": "0.487.0",
  "shadcn-ui components": "various"
}
```

### Dev Dependencies
```json
{
  "@vitejs/plugin-react": "4.7.0",
  "@tailwindcss/vite": "4.1.12",
  "typescript": "latest"
}
```

---

## Versiones Pinned

```yaml
Node.js:     18+ (recomendado 20+)
npm:         10+
TypeScript:  5.0+
React:       18.3.1
Vite:        6.3.5
Tailwind:    4.1.12
```

---

## Alternativas Futuras

### Si necesitas SSR:
- **Next.js:** Full-stack React framework
- **Remix:** Compiler-focused framework
- **Astro:** Static-first framework

### Si necesitas Mobile:
- **React Native:** iOS/Android
- **Flutter:** iOS/Android (no React)
- **Capacitor:** Web-to-mobile bridge

### Si necesitas Desktop:
- **Electron:** Electron app
- **Tauri:** Rust + Web

---

**Última actualización:** 16 de Mayo, 2026
