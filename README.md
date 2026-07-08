# Sistema de Gestión de Base de Datos - Colombina S.A.

Proyecto académico desarrollado en **PostgreSQL** para modelar los procesos de abastecimiento, inventario, comercialización y gestión administrativa de Colombina S.A., aplicando los principios del diseño de bases de datos relacionales, normalización e integridad referencial.

---

# Sobre la empresa

Colombina S.A. es una empresa colombiana fundada en el Valle del Cauca con más de 95 años de experiencia en la producción y comercialización de alimentos. Actualmente comercializa sus productos en más de 80 países y cuenta con un amplio portafolio que incluye confitería, chocolates, galletas, helados, salsas, conservas y otras categorías de alimentos.

El presente proyecto modela parte de sus procesos de negocio relacionados con la administración de productos, clientes, proveedores, compras, ventas, inventario, plantas de producción, empleados y accionistas.

---

# Diagrama Entidad-Relación

El diagrama del modelo entidad-relación se encuentra en la carpeta:

```
docs/
```

Puede visualizarse directamente a continuación:

![Modelo ER](docs/MER.png)



---

# Estructura del proyecto

```text
Proyecto-COLOMBINA-S.A/
│
├── app/                # Proyecto Django
├── db/                 # Scripts SQL
├── docs/               # Documentación
├── templates/          # Plantillas HTML
├── static/             # CSS, JS e imágenes
│
├── requirements.txt    # Dependencias del proyecto
├── .env.example        # Ejemplo de configuración
├── README.md
├── LICENSE
└── DOC_IA.md           # Bitacora de uso responsable de IA
```

---

# Tecnologías utilizadas

- PostgreSQL
- SQL
- pgAdmin 4/Dbeaver
- Git
- GitHub

---

# Requisitos

Antes de ejecutar el proyecto se requiere:

- PostgreSQL instalado.
- pgAdmin 4 (opcional, tambien se puede usar Dbeaver).
- Una base de datos vacía donde se ejecutarán los scripts.

---

# Pre-ejecución del proyecto
## 1. Clonar el repositorio

Abrir una terminal (CMD o PowerShell) y ejecutar:

```bash
git clone https://github.com/majo181504/Proyecto-COLOMBINA-S.A.git
cd Proyecto-COLOMBINA-S.A
```

---

## 2. Crear el entorno virtual

Desde la carpeta del proyecto ejecutar:

```bash
python -m venv .venv
```

Esto creará una carpeta llamada `.venv` que contendrá todas las dependencias del proyecto.

---

## 3. Activar el entorno virtual

### Si estás usando CMD:

```cmd
.venv\Scripts\activate.bat
```

### Si estás usando PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

Si el entorno se activó correctamente, deberías ver algo parecido a:

```text
(.venv) C:\Users\TuUsuario\Proyecto-COLOMBINA-S.A>
```

---

## 4. Instalar las dependencias del proyecto

Con el entorno virtual activado ejecutar:

```bash
pip install -r requirements.txt
```

Este comando instalará automáticamente:

- Django
- psycopg2-binary
- python-decouple
- y cualquier otra dependencia utilizada en el proyecto.

---

## 5. Crear el archivo de configuración local

Copiar el archivo de ejemplo:

```cmd
copy .env.example .env
```

Ahora abrir el archivo `.env` y modificar únicamente las credenciales de PostgreSQL.

Ejemplo:

```env
DB_NAME=colombina-db
DB_USER=postgres
DB_PASSWORD=tu_contraseña
DB_HOST=localhost
DB_PORT=5432

SECRET_KEY=django-insecure-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
DEBUG=True
```

## Importante

El archivo `.env` contiene información privada y **NO debe subirse a GitHub**.

---

## 6. Verificar la conexión con la base de datos

Entrar a la carpeta de la aplicación:

```bash
cd app
```

Ejecutar:

```bash
python manage.py check
```

Si todo está correcto, aparecerá:

```text
System check identified no issues (0 silenced).
```

---

## 7. Ejecutar las migraciones de Django

```bash
python manage.py migrate
```

Este comando crea las tablas internas que necesita Django para funcionar.

**No modifica las tablas del proyecto COLOMBINA S.A.**

---

## 8. Iniciar el servidor

```bash
python manage.py runserver
```

Si todo salió bien aparecerá algo similar a:

```text
Starting development server at http://127.0.0.1:8000/
```

Abrir en el navegador:

```text
http://127.0.0.1:8000/
```

Si aparece la página de bienvenida de Django, el proyecto está listo para comenzar a desarrollar.

---

# Ejecución del proyecto

## 1. Crear la base de datos

Crear una base de datos vacía en PostgreSQL.

Por ejemplo:

```sql
CREATE DATABASE colombina;
```

Posteriormente conectarse a dicha base de datos.

---

## 2. Crear el esquema

Dirigirse a la carpeta:

```
db/schema
```

Ejecutar el script correspondiente al esquema de la base de datos.

Este archivo crea todas las tablas, restricciones, claves primarias y claves foráneas del proyecto.

---

## 3. Poblar la base de datos

Dentro de la carpeta

```
db/seed
```

se encuentran los archivos SQL que contienen los datos sintéticos.

Ejecutarlos en **orden numérico ascendente** para evitar problemas de integridad referencial.

Ejemplo:

```
01_...

02_...

03_...

...

08_ventas.sql
```

Cada archivo depende del anterior debido a las relaciones entre las tablas.

---

## 4. Ejecutar las consultas

Una vez cargada toda la información, ingresar a

```
database/queries
```

y ejecutar cada consulta SQL.

Todas las consultas deben retornar información correctamente si los pasos anteriores fueron ejecutados en el orden indicado.

---

# Datos sintéticos

Los datos utilizados en este proyecto fueron generados sintéticamente con apoyo de modelos de lenguaje (LLM), siguiendo criterios de consistencia e integridad referencial.

Los datos fueron diseñados para representar un escenario realista del funcionamiento de Colombina S.A., incorporando:

- Productos con diferentes niveles de popularidad.
- Clientes con distintos volúmenes de compra.
- Variaciones temporales en compras y ventas.
- Relaciones consistentes entre proveedores, productos e inventarios.

---

# Autores

- David Alejandro García Grueso
- María José Gonzalez Rosero
- Carlos Ocoró Velez
  
Proyecto desarrollado como trabajo académico para la asignatura **Bases de Datos**.
