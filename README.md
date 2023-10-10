## Tracker

Приложение для трекинга привычек. Приложение помогает пользователям формировать полезные привычки и контролировать их выполнение.
Цели приложения:

- Контроль привычек по дням недели.
- Просмотр прогресса по привычкам.

<img src="https://github.com/shishmakovaDaria/ImageFeed/assets/114743567/caf88e22-fda5-4c2b-849c-089a4c752ebe" width="150">
<img src="https://github.com/shishmakovaDaria/ImageFeed/assets/114743567/6b3a6431-e25f-4488-bc0e-e28a5ee2e143" width="150">
<img src="https://github.com/shishmakovaDaria/ImageFeed/assets/114743567/60868154-db28-4a72-95c6-d45ba11d3fd4" width="150">
<img src="https://github.com/shishmakovaDaria/ImageFeed/assets/114743567/5e30df4b-6203-4428-ad10-1fcae9274124" width="150">
<img src="https://github.com/shishmakovaDaria/ImageFeed/assets/114743567/5b30b7db-cea9-48eb-bc62-440e6a834101" width="150">
<img src="https://github.com/shishmakovaDaria/ImageFeed/assets/114743567/2ffaa7ac-621a-4d60-9ad7-1c567499e83d" width="150">
<img src="https://github.com/shishmakovaDaria/ImageFeed/assets/114743567/66dd6c4b-ba40-4fef-95d1-5702b9e7e8fd" width="150">
<img src="https://github.com/shishmakovaDaria/ImageFeed/assets/114743567/0c5a6313-6bbc-4bee-83ab-32db2ae57cbe" width="150">
<img src="https://github.com/shishmakovaDaria/ImageFeed/assets/114743567/b9a30e68-6abe-4b20-a5eb-a625e7cf3b76" width="150">
<img src="https://github.com/shishmakovaDaria/ImageFeed/assets/114743567/e2db10a8-f288-470e-b336-4814e04c956b" width="150">

## Ссылки

[Дизайн Figma](https://www.figma.com/file/owAO4CAPTJdpM1BZU5JHv7/Tracker-(YP)?t=SZDLmkWeOPX4y6mp-0)

## Описание приложения

- Приложение состоит из карточек-трекеров, которые создает пользователь. Он может указать название, категорию и задать расписание. Также можно выбрать эмодзи и цвет, чтобы отличать карточки друг от друга.
- Карточки отсортированы по категориям. Пользователь может искать их с помощью поиска и фильтровать.
- С помощью календаря пользователь может посмотреть какие привычки у него запланированы на конкретный день.
- В приложении есть статистика, которая отражает успешные показатели пользователя, его прогресс и средние значения.

## Стек технологий
- Swift
- UIKit
- MVVM
- CoreData
- CocoaPods
- SPM
- YandexMobileMetrica
- SnapshotTesting
- AutoLayout programmaticaly
- Localization
- Dark Mode

## Функциональные требования
- Онбординг (При первом входе в приложение пользователь попадает на экран онбординга).
- Создание карточки привычки (На главном экране пользователь может создать трекер для привычки или нерегулярного события. Привычка – событие, которое повторяется с определенной периодичностью. Нерегулярное событие не привязано к конкретным дням).
- Просмотр главного экрана (На главном экране пользователь может просмотреть все созданные трекеры на выбранную дату, отредактировать их и посмотреть статистику).
- Редактирование и удаление категории (Во время создания трекера пользователь может отредактировать категории в списке или удалить ненужные).
- Просмотр статистики (Во вкладке статистики пользователь может посмотреть успешные показатели, свой прогресс и средние значения).
- Темная тема (В приложении есть темная тема, которая меняется в зависимости от настроек системы устройства).

## Технические требования

- Приложение должно поддерживать iPhone X и выше и адаптировано под iPhone SE, минимальная поддерживаемая версия операционной системы - iOS 13.4;
- В приложении используется стандартный шрифт iOS – SF Pro.
- Для хранения данных о привычках используется Core Data.
