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

- `GET` **`/`**

  Получить информацию о текущем пользователе

- `PATCH` **`/update`**

  Обновить информацию

- `PATCH` **`/update-password`**

  Обновить пароль

- `GET` **`/subscriptions`**

  Получить список подписок

- `GET` **`/subscribers`**

  Получить список подписчиков

- `DELETE` **`/delete`**

  Удалить свой аккаунт

### `/admin`

- `DELETE` **`/users/{user_id}`**

  Удалить юзера и все его ивенты

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

- `GET` **`/{userId}`**

  Получить информацию о пользователе

- `POST` **`/{userId}/subscribe`**

  Подписаться на пользователя

- `POST` **`/{userId}/unsubscribe`**

  Отписаться от пользователя
