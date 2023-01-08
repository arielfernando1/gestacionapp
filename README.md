# BabyPhotoStory

Aplicacion con el proposito de que las madres en gestacion puedan registrar los recuerdos de su embarazo mediante fotos, audios y texto para luego generar un archivo pdf con todos los datos registrados.

Se usa Firestore para almacenar los datos de los usuarios y sus fotos, audios y textos.

Las acciones que el usuario puede realizar sobre un post son:

* Crear un post
* Editar un post
* Eliminar un post

Un post puede ser de tipo:

* Foto
* Audio
* Texto

La estructura de un post es la siguiente:

```json
{
  "id": "string",
  "type": "int", // 0: foto, 1: audio, 2: texto
  "title": "string",
  "description": "string",
  "date_created": "string",
  "file": "string", // archivo codificado en base64
  "uuid": "string" // ID del usuario que creó el post
}
```
Librerias usadas:

* [google_sign_in](https://pub.dev/packages/google_sign_in) 
* [firebase_auth](https://pub.dev/packages/firebase_auth)
* [cloud_firestore](https://pub.dev/packages/cloud_firestore)
* [firebase_storage](https://pub.dev/packages/firebase_storage)
* [file_picker](https://pub.dev/packages/file_picker)


