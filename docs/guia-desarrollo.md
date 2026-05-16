# 🛠️ Guía de Desarrollo - GŌKU LAB

## ✅ Requisitos Previos

- Node.js 18+ (o 20+ recomendado)
- npm o pnpm
- Git
- Docker (opcional pero recomendado)
- Editor de código (VS Code recomendado)

---

## 🚀 Inicio Rápido

### 1. Clonar el ecosistema
```bash
git clone https://github.com/jcrendon0909/Gokulab.git
cd Gokulab
```

### 2. Clonar proyectos que necesites
```bash
# Para trabajar con el website
git clone https://github.com/jcrendon0909/GokuLab_WebSite.git
cd GokuLab_WebSite
npm install
npm run dev
```

---

## 📁 Estructura de Carpetas (Website)

```
GokuLab_WebSite/
├── src/
│   ├── app/
│   │   ├── components/     # Componentes reutilizables
│   │   ├── pages/         # Páginas (rutas)
│   │   ├── contexts/      # React contexts (idioma, tema)
│   │   ├── hooks/         # Custom hooks
│   │   ├── routes.tsx     # Definición de rutas
│   │   └── Layout.tsx     # Layout principal
│   ├── main.tsx           # Entry point
│   ├── styles/            # Estilos globales
│   └── imports/           # Assets importados (Figma)
├── public/                # Assets estáticos
├── index.html             # HTML principal
├── package.json           # Dependencias
├── vite.config.ts         # Config Vite
└── tailwind.config.js     # Config Tailwind
```

---

## 🎨 Stack Tecnológico (Website)

### Frontend
- **React 18:** Framework UI
- **TypeScript:** Type safety
- **Vite 6:** Build tool (super rápido)
- **Tailwind CSS 4:** Utility-first CSS
- **React Router v7:** Enrutamiento
- **Framer Motion:** Animaciones
- **next-themes:** Dark/Light mode
- **shadcn/ui:** Componentes pre-diseñados
- **Lucide React:** Iconos

---

## 💻 Comandos Útiles

### Desarrollo
```bash
npm run dev          # Inicia servidor de desarrollo
npm run build        # Build para producción
npm run preview      # Preview del build
```

### Linting y Formato
```bash
npm run lint         # Ejecutar linter
npm run format       # Formatear código
```

---

## 🌐 Multiidioma

### Cómo funciona
- Context API: `LanguageContext`
- Hook: `useLanguage()`
- Archivo de traducciones: `/src/app/contexts/LanguageContext.tsx`

### Uso en componentes
```tsx
import { useLanguage } from "../contexts/LanguageContext";

function MyComponent() {
  const { t, language, setLanguage } = useLanguage();
  
  return (
    <>
      <h1>{t("hero.title")}</h1>
      <button onClick={() => setLanguage('es')}>ES</button>
      <button onClick={() => setLanguage('en')}>EN</button>
    </>
  );
}
```

### Agregar nuevas traducciones
1. Abre `/src/app/contexts/LanguageContext.tsx`
2. Localiza el objeto `translations`
3. Agrega nuevas claves en cada idioma:
```tsx
translations: {
  es: {
    "mi_nueva_clave": "Texto en español"
  },
  en: {
    "mi_nueva_clave": "Text in English"
  },
  pt: {
    "mi_nueva_clave": "Texto em português"
  }
}
```

---

## 🌙 Dark Mode

### Cómo funciona
- Librería: `next-themes`
- Provider: `ThemeProvider` en Layout.tsx
- Hook: `useTheme()`

### Uso en componentes
```tsx
import { useTheme } from "next-themes";

function MyComponent() {
  const { theme, setTheme } = useTheme();
  
  return (
    <div className="bg-white dark:bg-black">
      <button onClick={() => setTheme(theme === "dark" ? "light" : "dark")}>
        Toggle Theme
      </button>
    </div>
  );
}
```

### Patrón de clases Tailwind
```tsx
className="
  bg-white           /* Light mode */
  dark:bg-black      /* Dark mode */
  transition-colors  /* Transición suave */
  duration-300       /* 300ms de duración */"
```

---

## 🔀 Creación de Ramas

### Convención
```
feature/descripcion-corta     # Nuevas funcionalidades
fix/descripcion-del-bug       # Correcciones
refactor/descripcion          # Refactorización
docs/descripcion              # Documentación
```

### Ejemplo
```bash
git checkout -b feature/agregar-carrito
# ... hacer cambios ...
git add .
git commit -m "feat: agregado carrito de compras"
git push origin feature/agregar-carrito
# Crear Pull Request en GitHub
```

---

## 🧪 Testing

### (Por implementar)
Recomendación:
- **Unit tests:** Vitest
- **Integration tests:** Cypress o Playwright
- **E2E tests:** Cypress

---

## 🔍 Debugging

### En VS Code
1. Instala extensión "Debugger for Chrome"
2. Abre `F5` o Debug panel
3. Selecciona "Chrome"

### React DevTools
1. Instala extensión en Chrome: "React Developer Tools"
2. Abre DevTools (F12)
3. Pestaña "Components" para inspeccionar estado

---

## 📝 Commits

### Formato (Conventional Commits)
```
feat: agregar nueva funcionalidad
fix: corregir bug en componente X
refactor: mejorar performance
docs: actualizar documentación
style: cambios de formato/linting
```

---

## 🚀 Despliegue

### Vercel (Recomendado)
1. Push a rama main
2. Vercel construye automáticamente
3. Deploy a producción

### Manual
```bash
npm run build
# Subir carpeta 'dist' a servidor
```

---

## 🆘 Troubleshooting

### Error: "Cannot find module"
```bash
rm -rf node_modules
npm install
```

### Error: Port 3000 ya en uso
```bash
# Cambiar puerto en vite.config.ts
# O matar proceso:
npx kill-port 3000
```

### Tailwind CSS no aplica estilos
```bash
# Rebuild Tailwind
npm run dev
# Si persiste, limpia caché:
rm -rf .next # (si usa Next.js)
```

---

## 📚 Recursos Útiles

- [React Docs](https://react.dev)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [Vite Guide](https://vitejs.dev/guide/)
- [React Router](https://reactrouter.com/)

---

**Última actualización:** 16 de Mayo, 2026
