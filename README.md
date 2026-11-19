# Preentrega 2 - Bases de Datos SQL

Proyecto retail en PostgreSQL. Incluye las tablas `clientes`, `productos` y `ventas`, con claves primarias, claves foráneas y restricciones de integridad.

## Cómo ejecutar

1. Abrir DBeaver y conectarse a PostgreSQL.
2. En una sesión conectada a la base `postgres`, ejecutar:

   ```sql
   CREATE DATABASE retail_project;
   ```

3. Conectarse a la nueva base `retail_project` y abrir un editor SQL.
4. Abrir `retail_project.sql` y ejecutar el script completo, desde el principio.
5. Revisar las consultas `SELECT` finales para verificar los datos.

**Importante:** Ejecutar el script en una base nueva y vacía. Si las tablas ya existen, el script puede fallar; no lo ejecutes dos veces sin reiniciar el esquema. El `DELETE` elimina una venta de prueba, por lo que quedan 4 ventas al finalizar, aunque se insertan inicialmente 5.
