# спецификация

### `/auth`

- `POST` **`/signup`** `UserPublic`

  Регистрация нового пользователя

- `POST` **`/signin`** `Token`

  Генерирует токен

- `POST` **`/logout`**

  Удаляет токен

- `POST` **`/resetpassword`**

  Сброс пароля

### `/account`

- `PATCH` **`/update`**

  Обновить информацию

- `GET` **`/subscriptions`**

  Получить список подписок

- `GET` **`/subscribers`**

  Получить список подписчиков

### `/event`

- `POST` **`/create`**

  Создать новый ивент

- `GET` **`/{evenId}`**

  Получить информацию об ивенте

- `POST` **`/{eventId}/subscribe`**

  Подписаться на ивент

- `POST` **`/{eventId}/unsubscribe`**

  Отписаться от ивента

- `DELETE` **`/{eventId}/delete`**

  Удалить ивент

### `/user`

- `GET` **`/{iserId}`**

  Получить информацию о пользователе

- `POST` **`/{userId}/subscribe`**

  Подписаться на пользователя

- `POST` **`/{userId}/unsubscribe`**

  Отписаться от пользователя
