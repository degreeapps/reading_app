# El Lectómetro

**Una app móvil para que niños y jóvenes lleven el seguimiento de sus lecturas, se motiven y compartan lo que leen.**

*English TL;DR: Flutter mobile app that helps kids and teenagers track their reading, write short reading reports and share progress with friends. Feature-first Clean Architecture, Bloc, Firebase and the Google Books API.*

---

## ¿Qué problema resuelve?

Leer por gusto se pierde fácilmente a partir de cierta edad. El Lectómetro convierte la lectura en algo que se puede seguir y compartir: cada lector tiene su biblioteca, ve cuánto lleva del libro actual, deja una pequeña ficha al terminarlo y puede ver qué leen sus amigos. Pensada para lectores infantiles y juveniles, con la opción de compartir las fichas con padres y profesores.

<!--
CAPTURAS (descomentar cuando las imágenes estén en docs/screenshots/):

| Mi Biblioteca | Buscar libros | Ficha de lectura | Amigos |
|---|---|---|---|
| ![Home](docs/screenshots/home.png) | ![Búsqueda](docs/screenshots/search.png) | ![Ficha](docs/screenshots/ficha.png) | ![Amigos](docs/screenshots/friends.png) |
-->

## Funcionalidades

**Mi Biblioteca**

- Libro actual con barra de progreso (%) que el lector actualiza mientras avanza.
- Al terminar un libro, la app felicita y ofrece rellenar la ficha de lectura.
- Vista previa de libros favoritos y listado de libros leídos.

**Buscar y elegir libros**

- Búsqueda en el catálogo de **Google Books** (título, autores, portada, páginas, categorías, descripción).
- Detalle del libro con acciones: *Leer ahora*, *Marcar como leído* y añadir a favoritos.
- Si ya hay un libro en curso, la app pregunta antes de reemplazarlo.

**Fichas de lectura**

- Valoración, resumen ("¿de qué trata?"), aprendizajes y opinión personal.
- Opciones para marcar la ficha como compartida con padres y con profesores.
- Guardar, editar y borrar con confirmación.

**Amigos**

- Búsqueda de usuarios, envío de invitaciones y bandeja de invitaciones recibidas (aceptar o rechazar).
- Lista de amigos, con acceso a su perfil y a sus libros, y opción de eliminar amigo.

**Cuenta y perfil**

- Registro e inicio de sesión con email y contraseña, o con Google.
- Perfil con nombre, edad y curso escolar.
- Cambio de contraseña, cierre de sesión y borrado de la cuenta.

**Detalles de producto**

- Tema claro y oscuro según el sistema, tipografía Poppins y animaciones de transición.
- Versión de la app visible en inicio de sesión, registro y perfil.

## Arquitectura y decisiones técnicas

Organizada **por funcionalidad (feature-first)** y con **Clean Architecture** dentro de cada una:

```
lib/
├── core/                     # tema, inyección de dependencias, widgets y animaciones comunes
└── features/
    ├── auth/                 # domain · data · presentation
    ├── books/                # domain · data · presentation
    ├── home/                 # presentation
    └── profile/              # domain · data · presentation (perfil y amigos)
```

- **domain:** entidades, interfaces de repositorio y casos de uso (uno por acción, por ejemplo `SendFriendRequest`, `SearchBooks`, `SignInWithGoogle`). No depende de Flutter ni de Firebase.
- **data:** implementaciones de repositorio y fuentes de datos (Firestore, Firebase Auth, Google Books).
- **presentation:** pantallas, widgets y **Bloc** como gestión de estado (`AuthBloc`, `BookBloc`, `ProfileBloc`).
- **Inyección de dependencias** con `get_it` + `injectable`.
- **Modelos inmutables y serialización** con `freezed` y `json_serializable`.
- **Reglas de seguridad de Firestore** versionadas en el repo (`firestore.rules`).
- Las claves y la configuración de Firebase **no se versionan**: se inyectan en tiempo de compilación (ver más abajo).

## Stack

| Área | Tecnología |
| --- | --- |
| App | Flutter / Dart (SDK ^3.7) |
| Estado | flutter_bloc |
| Backend | Firebase Auth, Cloud Firestore |
| Datos externos | Google Books API |
| DI y modelos | get_it, injectable, freezed, json_serializable |
| UI | Material 3 (tema claro/oscuro), google_fonts, cached_network_image |

## Cómo ejecutarlo

Requisitos: Flutter instalado, un proyecto de Firebase propio y una clave de la API de Google Books.

```bash
git clone https://github.com/degreeapps/reading_app.git
cd reading_app
flutter pub get

# Configuración de Firebase (genera lib/firebase_options.dart y google-services.json)
dart pub global activate flutterfire_cli
flutterfire configure

# Clave de Google Books (env.json está en .gitignore)
cp env.example.json env.json      # y rellena GOOGLE_BOOKS_API_KEY

flutter run --dart-define-from-file=env.json
```

Reglas de Firestore: `firebase deploy --only firestore:rules`.

El código generado (`freezed`, `json_serializable`, `injectable`) está versionado. Si cambias modelos o la inyección, regenéralo con `dart run build_runner build --delete-conflicting-outputs`.

## Flujo de trabajo del repositorio

El repositorio sigue **GitFlow**: `main` contiene solo versiones publicadas (con tag), el trabajo diario va en `develop` y cada cambio en una rama `feature/*`. La versión se define en `pubspec.yaml` (semver) y se muestra dentro de la app.

## Estado y próximos pasos

El proyecto es funcional y sigue en evolución. Lo siguiente en la lista:

- [ ] Tests unitarios de los casos de uso y los Bloc, y tests de widget de los flujos principales.
- [ ] Integración continua (análisis estático y tests en cada pull request).
- [ ] Entornos `dev` y `staging` con flavors.
- [ ] Endurecer las reglas de seguridad de Firestore.

## Autor

**Juan Miguel Grau** — desarrollador con más de 20 años de experiencia (backend Java, ex-CTO, Flutter).
[LinkedIn](https://linkedin.com/in/juanmigrau)
