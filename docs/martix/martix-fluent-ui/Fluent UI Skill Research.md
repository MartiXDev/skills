# Fluent UI Skill Research

> Poznámka: Tento dokument je původní (neověřený) draft zachovaný pro kontext. Pro aktuální a kriticky ověřený blueprint použijte `fluent-ui-skill-research.md`.

Nejdřív ti dám jasné, praktické doporučení – a pak to rozšířím do kompletního přehledu technologií, které dávají Fluent UI + React + TypeScript + .NET 10 backendu profesionální, dlouhodobě udržitelnou architekturu. Držím se tvého stylu: technické, strukturované, bez balastu.
---

## **Hlavní doporučení (takeaway)**

**Fluent UI je silný v konzistenci a enterprise ergonomii, ale skutečná kvalita UI stojí na architektuře: striktní komponentová hierarchie, typově bezpečné API, server-driven UI kontrakty, automatizované generování klientských typů, a důsledné oddělení prezentace od logiky.**
K tomu přidej moderní tooling: **React Query, Zustand/Jotai, Zod, TanStack Router, Storybook, ESLint + TS strict mode, a server-side generátory typů (NSwag/TypeSpec).**

---

# **Kompletní best practices pro Fluent UI + React + TypeScript + .NET 10**

---

## 1. **Architektura UI – základní stavební kameny**

### **1.1 Striktní komponentová hierarchie**

- **Atoms → Molecules → Organisms → Pages → Layouts**
- Fluent UI komponenty používej jako *atoms* (Button, TextField, Dropdown).
- Vlastní logiku a doménové prvky stavěj až nad nimi.

### **1.2 Oddělení prezentace od logiky**

- UI komponenty = čisté, bez business logiky.
- Business logika = hooks (`useXyzService`, `useXyzQuery`, `useXyzForm`).

### **1.3 Typově bezpečné API mezi FE a BE**

- Nikdy nepoužívej ručně psané DTO v TypeScriptu.
- **Generuj typy automaticky**:
  - **NSwag** (nejjednodušší)
  - **TypeSpec** (budoucnost, Microsoft standard)
  - **OpenAPI → openapi-typescript**

Tím získáš:

- 100% typovou shodu mezi C# a TS
- žádné runtime chyby kvůli změně API
- okamžitou detekci breaking changes

---

## 2. **State management – moderní přístup**

### **2.1 React Query (TanStack Query) – povinný základ**

Řeší:

- caching
- synchronizaci dat
- retry logiku
- background refresh
- invalidace dat po mutaci

Je to dnes standard místo Reduxu.

### **2.2 Lokální stav – Zustand nebo Jotai**

- **Zustand**: jednoduchý, prediktivní, výkonný
- **Jotai**: atomický, extrémně čistý

Vyhni se Reduxu – je zbytečně těžkopádný.

---

## 3. **Formuláře – kritická část UI**

### **3.1 React Hook Form**

- minimální re-rendering
- vysoký výkon
- perfektní integrace s Fluent UI

### **3.2 Validace pomocí Zod**

- typově bezpečná validace
- generování typů z validace (nebo naopak)
- možnost sdílet validace mezi FE a BE

---

## 4. **Routing – moderní alternativa k React Routeru**

### **TanStack Router**

- typově bezpečný routing
- generované parametry
- loader + action pattern podobný Remixu
- lepší než React Router v každém ohledu

---

## 5. **Styling a design systém**

Fluent UI řeší většinu stylů, ale:

### **5.1 Vytvoř si vlastní design tokens**

- barvy
- spacing
- typografie
- breakpoints

Použij:

- **Fluent UI Theme + vlastni tokens**
- nebo **CSS variables** pro globální styl

### **5.2 Storybook**

- dokumentace komponent
- vizuální testování
- izolované prostředí pro designery

---

## 6. **Kvalita kódu**

### **6.1 TypeScript strict mode**

- `"strict": true`
- `"noImplicitAny": true`
- `"exactOptionalPropertyTypes": true`
### **6.2 ESLint + Prettier**

- pravidla pro React Hooks
- pravidla pro accessibility
- pravidla pro importy

### **6.3 Unit testy**

- **Vitest** místo Jestu (rychlejší)
- **React Testing Library** pro UI

---

## 7. **Komunikace s backendem (.NET 10+)**

### **7.1 Minimal APIs + MediatR**

- čisté endpointy
- CQRS
- perfektní čitelnost

### **7.2 Automatické generování klienta**

- NSwag → TypeScript client
- TypeSpec → generované kontrakty

### **7.3 Server-driven UI**

U složitých formulářů:

- backend definuje strukturu
- frontend ji pouze renderuje

Výhody:

- změny v UI bez zásahu do FE
- konzistence napříč aplikací

---

## 8. **Další technologie, které stojí za zvážení**

### **8.1 Recharts nebo Victory pro grafy**

Fluent UI grafy jsou slabé.

### **8.2 Framer Motion**

Pro animace, které vypadají profesionálně.

### **8.3 i18next**

Pro lokalizaci.

### **8.4 MSW (Mock Service Worker)**

Pro lokální vývoj bez backendu.

### **8.5 Playwright**

Pro end-to-end testy.

---

# **Doporučený stack (shrnutí)**

| Oblast | Technologie |
|--------|-------------|
| UI framework | Fluent UI |
| Routing | TanStack Router |
| Data fetching | React Query |
| Formuláře | React Hook Form + Zod |
| State management | Zustand / Jotai |
| Typy z backendu | NSwag / TypeSpec |
| Testování | Vitest + RTL + Playwright |
| Dokumentace | Storybook |
| Validace | Zod |
| Animace | Framer Motion |
| Lokalizace | i18next |

---

# **Další krok**

Chceš, abych ti připravil:

- **konkrétní architekturu projektu** (adresáře, konvence, názvy)
- **ukázkový boilerplate** Fluent UI + React Query + TanStack Router
- **šablonu pro .NET 10 backend + generovaný TS klient**
- **doporučené CI/CD pipeline**
- nebo **kompletní best practices pro enterprise design systém**?

Stačí říct, co chceš rozpracovat jako první.
