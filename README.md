## Содержание  по проекту "Комфорт отель"
### Как установить проект
[Установка проекта](#install_PO) 
### Документация кода
[models.py](#models.py)  
[views.py](#views.py)  
[forms.py](#forms.py)  
[urls.py](#urls.py)  
[admin.py](#admin.py)  
[ERD](#erd_diddy)

### &nbsp;
### &nbsp;

# <a name="install_PO">Установка проекта</a>

### Создайте пустую папку и загрузите в него [Start.bat](https://github.com/Alexandr1810/HostelComfort/tree/ilya/.bat) и запустите
### По-итогу завершения работы bat файла будут установлены все библиотеки и созданы необходимые файлы для работы сайта  
### После в директории ../Hostle-Comfort/myproject откройте консоль и пропишите следующие команды по порядку:
```
python manage.py makemigrations
python manage.py migrate
python manage.py migrate product 
python manage.py migrate sessions
python manage.py createsuperuser
```
### Далее всё в той же командной строке введите команду:
``` 
python manage.py runserver 
```
### Откроется наш проект с которым и предстоит работать

### &nbsp;
### &nbsp;

# <a name="models.py">Model.py от Sergay</a> 

## Создание  таблиц в базе данных

#### Импорты
``` python
from django.db import models
from django.core.validators import MaxValueValidator, MinValueValidator
from django.contrib.auth.models import User
from django.core.exceptions import ValidationError
```

#### Cоздание таблицы  Hotel и её атрибуты,также имеется рейтинг ограниченный выбором от 0 до 5

```python
class Hotel(models.Model):
    RATING_CHOICES = [
        (0, '0'),
        (1, '1'),
        (2, '2'),
        (3, '3'),
        (4, '4'),
        (5, '5'),
    ]
    name = models.CharField('Название', max_length=50)
    address = models.CharField('Адрес', max_length=50)
    contact_phone = models.CharField('Контактный номер', max_length=11)
    email = models.CharField('Email', max_length=100)
    description = models.CharField('Описание', max_length=100)
    rating = models.IntegerField(choices=RATING_CHOICES)
```
#### вывод данных в браузер для таблицы Отель
```python
    def __str__(self):
        return self.name
```
#### подмена  названий на Отель, Отели
```python
    class Meta:
        verbose_name = 'Отель'
        verbose_name_plural = 'Отели'
```
## Выбор комнаты по её типу и какие удобства в них есть
```python
class Room(models.Model):
    ROOM_TYPE_CHOICES = [
        (0, 'Одноместный'),
        (1, 'Двуместный'),
        (2, 'Люкс'),
    ]
    room_number = models.IntegerField('Номер комнаты')
    hotel_id = models.ForeignKey(Hotel, on_delete=models.CASCADE, verbose_name='Отель')
    type = models.IntegerField('Тип комнаты', choices=ROOM_TYPE_CHOICES)
    minbar = models.BooleanField('Мини-Бар', default=True)
    conditioner = models.BooleanField('Кондиционер', default=True)
    television = models.BooleanField('Телевизор', default=True)
    hairdryer = models.BooleanField("Фен", default = True)
    safe = models.BooleanField("Сейф в номере", default = True)
    Kettle_or_coffee_maker = models.BooleanField("Чайник или кофеварка", default = True)
    Sound_insulation = models.BooleanField("Звукоизоляция", default = True)
    Balcony_or_terrace = models.BooleanField("Балкон или терраса", default = True)
    special_for_ivalid = models.BooleanField("Удобства для людей с ограниченными возможностями", default = True)
    Telephone = models.BooleanField("Телефон", default = True)
    Fridge = models.BooleanField("Холодильник", default = True)
    Underfloor_heating = models.BooleanField("Пол с подогревом", default = True)
    Work_facilities = models.BooleanField("Удобства для работы", default = True)
    Baby_cot_services = models.BooleanField("Услуги по предоставлению детской кроватки", default = True)
    price = models.IntegerField('Цена')
```
#### вывод данных в браузер для таблицы Room
```python
    def __str__(self):
        room_num_display = f" №{self.room_number}" if self.room_number else ""
        return f"{self.get_type_display()}{room_num_display} (Отель: {self.hotel_id.name})"
```    
#### подмена  названий на Комната, Комнаты для интерфейса админа
```  python
    class Meta:
        verbose_name = 'Комната'
        verbose_name_plural = 'Комнаты'
```
## Таблица Clients
```python
class Clients(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE) 
    phio = models.CharField('ФИО', max_length=100)
    phone = models.CharField('Телефонный номер', max_length=11)
    email = models.CharField('Email', max_length=100)
    passport_seria = models.IntegerField('Серия паспорта')
    passport_num = models.IntegerField('Номер паспорта')
```
#### вывод данных в браузер для таблицы Clients
```python
    def __str__(self):
        return self.phio
```
#### подмена  названий на Клиент, Клиенты для интерфейса админа
```python
    class Meta:
        verbose_name = 'Клиент'
        verbose_name_plural = 'Клиенты'
```

## таблица Reservations
```python
class Reservations(models.Model):
    client_id = models.ForeignKey(Clients, on_delete=models.CASCADE, verbose_name='Клиент')
    room_id = models.ForeignKey(Room, on_delete=models.CASCADE, verbose_name='Комната')
    check_in_date = models.DateTimeField('Дата заезда')
    departure_date = models.DateTimeField('Дата выезда')
    total_amount = models.IntegerField('Общая сумма')
```
#### вывод данных в браузер для таблицы Reservations
```python
    def __str__(self):
        return f"Бронирование #{self.id} - {self.client_id.phio}"
```
#### подмена  названий на Бронирование, Бронирования для интерфейса админа
```python
    class Meta:
        verbose_name = 'Бронирование'
        verbose_name_plural = 'Бронирования'
```

## таблица Reviews_and_ratings
```python
class Reviews_and_ratings(models.Model):
    client_id = models.ForeignKey(Clients, on_delete=models.CASCADE, verbose_name='Клиент')
    hotel_id = models.ForeignKey(Hotel, on_delete=models.CASCADE, verbose_name='Отель')
    estimation = models.IntegerField('Оценка', validators=[MinValueValidator(1), MaxValueValidator(5)])
    comment = models.CharField('Комментарий', max_length=200)
    date = models.DateTimeField('Дата публикации', auto_now_add=True)
```
#### функци проверки корректности введённой даты
```python
    def clean(self):
      if self.departure_date <= self.check_in_date:
        raise ValidationError("Дата выезда должна быть позже даты заезда")
```
#### возвращение строки с отзывом клиента и оценкой
```python
    def __str__(self):
        return f"Отзыв от {self.client_id.phio} ({self.estimation}/5)"
```
#### подмена  названий на Отзывы и оценки для интерфейса админа
```python
    class Meta:
        verbose_name = 'Отзыв и оценка'
        verbose_name_plural = 'Отзывы и оценки'
```

### &nbsp;

# <a name="views.py">Views.py от Sergay</a> 

#### Импорт необходимых модулей для работы с запросами и аутентификацией
```python
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
from django.contrib import messages
from django.core.exceptions import ObjectDoesNotExist
from django.http import HttpResponseForbidden
from django.utils import timezone
from .models import Hotel, Room, Clients, Reservations, User, Reviews_and_ratings
from .forms import RegisterForm, LoginForm, Add, RoomForm
```

#### Основная логика отображения и фильтрации отелей
```python
# Обрабатывает запросы к главной странице с отелями, поддерживает фильтрацию по цене и удобствам
def hotel(request):
    min_price = request.GET.get('min_price')
    max_price = request.GET.get('max_price')
    # Фильтр удобств по полученным параметрам
    amenities_filters = {
        'minbar': request.GET.get('minbar') == 'on',
        'conditioner': request.GET.get('conditioner') == 'on',
        'television': request.GET.get('tv') == 'on',
        'hairdryer': request.GET.get('hairdryer') == 'on',
        'safe': request.GET.get('safe') == 'on',
        'Kettle_or_coffee_maker': request.GET.get('Kettle_or_coffee_maker') == 'on',
        'Sound_insulation': request.GET.get('Sound_insulation') == 'on',
        'Balcony_or_terrace': request.GET.get('Balcony_or_terrace') == 'on',
        'special_for_ivalid': request.GET.get('special_for_ivalid') == 'on',
        'Telephone': request.GET.get('Telephone') == 'on',
        'Fridge': request.GET.get('Fridge') == 'on',
        'Underfloor_heating': request.GET.get('Underfloor_heating') == 'on',
        'Work_facilities': request.GET.get('Work_facilities') == 'on',
        'Baby_cot_services': request.GET.get('Baby_cot_services') == 'on',
    }
```

#### Проверка применения фильтров и получение отфильтрованных отелей
```python
    filters_applied = any([
        min_price,
        max_price,
        any(amenities_filters.values())
    ])
    if filters_applied:
        # Фильтрация комнат по удобствам и цене
        rooms = Room.objects.all()
        if min_price:
            try:
                min_price_val = float(min_price)
                rooms = rooms.filter(price__gte=min_price_val)
            except ValueError:
                pass
        if max_price:
            try:
                max_price_val = float(max_price)
                rooms = rooms.filter(price__lte=max_price_val)
            except ValueError:
                pass
        for amenity, selected in amenities_filters.items():
            if selected:
                filter_kwargs = {amenity: True}
                rooms = rooms.filter(**filter_kwargs)
        # Получение уникальных идентификаторов отелей из отфильтрованных комнат
        hotel_ids = rooms.values_list('hotel_id', flat=True).distinct()
        # Получение отелей по идентификаторам
        hotels = Hotel.objects.filter(id__in=hotel_ids)
    else:
        # Если фильтры не применены, возвращаем все отели
        hotels = Hotel.objects.all()
    # Для каждого отеля собираем типы комнат и минимальную цену
    for hotel in hotels:
        rooms = Room.objects.filter(hotel_id=hotel.id)
        room_types = set(room.get_type_display() for room in rooms)
        hotel.room_types = room_types
        min_price_room = rooms.order_by('price').first()
        hotel.price = min_price_room.price if min_price_room else None
    context = {
        'hotel': hotels,
        'min_price': min_price,
        'max_price': max_price,
        'selected_amenities': amenities_filters,
    }
    return render(request, 'hotel/index.html', context)
```

#### Отображение информации об отеле и обработка отзывов
```python
def hotel_info(request, id):
    hotel = get_object_or_404(Hotel, id=id)
    rooms = Room.objects.filter(hotel_id=hotel.id)
    client = None
    if request.user.is_authenticated:
        try:
            client = request.user.clients
        except User.clients.RelatedObjectDoesNotExist:
            pass
    if request.method == 'POST':
        if client:
            estimation = request.POST.get('estimation', 5)
            comment = request.POST.get('comment', '').strip()
            if comment:
                Reviews_and_ratings.objects.create(
                    client_id=client,
                    hotel_id=hotel,
                    estimation=estimation,
                    comment=comment,
                    date=timezone.now()
                )
                messages.success(request, 'Ваш отзыв успешно добавлен.')
                return redirect('hotel_info', id=hotel.id)
        else:
            messages.error(request, 'Для добавления отзыва необходимо войти в систему.')
    comments = Reviews_and_ratings.objects.filter(hotel_id=hotel).order_by('-date')
```

#### Сбор удобств, доступных в номерах отеля
```python
    amenities_set = set()
    for room in rooms:
        if room.minbar:
            amenities_set.add('Мини-Бар')
        if room.conditioner:
            amenities_set.add('Кондиционер')
        if room.television:
            amenities_set.add('Телевизор')
        if room.hairdryer:
            amenities_set.add('Фен')
        if room.safe:
            amenities_set.add('Сейф в номере')
        if room.Kettle_or_coffee_maker:
            amenities_set.add('Чайник или кофеварка')
        if room.Sound_insulation:
            amenities_set.add('Звукоизоляция')
        if room.Balcony_or_terrace:
            amenities_set.add('Балкон или терраса')
        if room.special_for_ivalid:
            amenities_set.add('Удобства для людей с ограниченными возможностями')
        if room.Telephone:
            amenities_set.add('Телефон')
        if room.Fridge:
            amenities_set.add('Холодильник')
        if room.Underfloor_heating:
            amenities_set.add('Пол с подогревом')
        if room.Work_facilities:
            amenities_set.add('Удобства для работы')
        if room.Baby_cot_services:
            amenities_set.add('Услуги по предоставлению детской кроватки')
```

#### Формирование контекста и рендеринг страницы информации об отеле
```python
    context = {
        'hotel': hotel,
        'rooms': rooms,
        'client': client,
        'comments': comments,
        'amenities_set': amenities_set,
    }
    return render(request, 'hotel/hotel_info.html', context)
```

#### Обработка бронирования комнаты с проверкой доступности и валидацией данных
```python
@login_required
def booking(request, id, room_number=None):
    hotel = get_object_or_404(Hotel, id=id)
    client = None
    try:
        client = request.user.clients
    except User.clients.RelatedObjectDoesNotExist:
        return HttpResponseForbidden("Профиль клиента не найден. Пожалуйста, заполните профиль.")
    room = None
    if room_number:
        try:
            room = Room.objects.get(room_number=room_number, hotel_id=hotel.id)
        except Room.DoesNotExist:
            messages.error(request, f"Комната с номером {room_number} не найдена.")
            return redirect('hotel_info', id=hotel.id)
    date_error = False
    booking_conflict = False
    reservation = None
    if request.method == 'POST':
        check_in_date = request.POST.get('check_in_date')
        departure_date = request.POST.get('departure_date') 
        if check_in_date and departure_date and room:
            try:
                check_in = timezone.datetime.strptime(check_in_date, '%Y-%m-%d').date()
                departure = timezone.datetime.strptime(departure_date, '%Y-%m-%d').date()         
                # Проверка что дата выезда не раньше даты заезда
                if departure <= check_in:
                    date_error = True
                else:
                    # Проверка доступности только для конкретного номера
                    overlapping_reservations = Reservations.objects.filter(
                        room_id=room,
                        check_in_date__lt=departure,
                        departure_date__gt=check_in
                    ).exists()           
                    if overlapping_reservations:
                        booking_conflict = True
                    else:
                        # Создание бронирования при успешных проверках
                        nights = (departure - check_in).days
                        total_amount = room.price * nights
                        Reservations.objects.create(
                            client_id=client,
                            room_id=room,
                            check_in_date=check_in,
                            departure_date=departure,
                            total_amount=total_amount
                        )
                        messages.success(request, f"Комната №{room.room_number} успешно забронирована.")
                        return redirect('booking_info', id=hotel.id, room_number=room.room_number)
            except ValueError:
                messages.error(request, "Неверный формат даты.")
        else:
            messages.error(request, "Пожалуйста, заполните все поля.")
    try:
        reservation = Reservations.objects.filter(client_id=client, room_id=room).latest('check_in_date')
    except Reservations.DoesNotExist:
        reservation = None
    context = {
        'hotel': hotel,
        'room': room,
        'check_in_date': request.POST.get('check_in_date', ''),
        'departure_date': request.POST.get('departure_date', ''),
        'date_error': date_error,
        'booking_conflict': booking_conflict,
        'reservation': reservation,
    }
    return render(request, 'hotel/booking.html', context)
```

#### Отображение информации о бронировании комнаты
```python
@login_required
def booking_info(request, id, room_number=None):
    hotel = get_object_or_404(Hotel, id=id)
    room = None
    reservation = None
    if room_number:
        try:
            room = Room.objects.get(hotel_id=hotel.id, room_number=room_number)
        except Room.DoesNotExist:
            room = None
    if room and request.user.is_authenticated:
        try:
            client = request.user.clients
            reservation = Reservations.objects.filter(client_id=client, room_id=room).latest('check_in_date')
        except (Reservations.DoesNotExist, AttributeError):
            reservation = None
    context = {
        'hotel': hotel,
        'room': room,
        'reservation': reservation,
    }
    return render(request, 'hotel/booking_info.html', context)
```

#### Регистрация пользователя и создание профиля клиента
```python
# Обработка регистрации нового пользователя и создание связанного профиля клиента
def register(request):
    if request.method == 'POST':
        form = RegisterForm(request.POST)
        if form.is_valid():
            user = form
            Clients.objects.create(
                user=user,
                phio=form.cleaned_data['phio'],
                phone=form.cleaned_data['phone'],
                email=form.cleaned_data['email'],
                passport_seria=form.cleaned_data['passport_seria'],
                passport_num=form.cleaned_data['passport_num']
            )
            login(request, user)
            return redirect('hotel') # Перенаправляем на главную страницу
        else:
            # Добавляем сообщения об ошибках
            for field, errors in form.errors.items():
                for error in errors:
                    messages.error(request, f"{field}: {error}")
    else:
        form = RegisterForm()
    return render(request, 'registration/register.html', {'form': form})
```

#### Вход пользователя в систему с проверкой аутентификации
```python
def user_login(request):
    if request.method == 'POST':
        form = LoginForm(request, data=request.POST)
        if form.is_valid():
            username = form.cleaned_data.get('username')
            password = form.cleaned_data.get('password')
            user = authenticate(request, username=username, password=password)
            if user is not None:
                login(request, user)
                if user.is_superuser:
                    return redirect('hotel_manager')
                else:
                    return redirect('user_profile')
        messages.error(request, 'Неверный телефон/email или пароль')
    else:
        form = LoginForm()
    return render(request, 'registration/login.html', {'form': form})
```

#### Выход пользователя из системы
```python
# Выход из аккаунта 
def user_logout(request):
    logout(request)
    return redirect('login')
```

#### Отображение профиля пользователя и его бронирований
```python
# Отображение профиля клиента и списка его бронирований
@login_required
def user_profile(request):
    try:
        client = request.user.clients
    except ObjectDoesNotExist:
        # Если клиент не существует, перенаправляем на заполнение профиля
        return redirect('register')
    reservations = Reservations.objects.filter(client_id=client)
    return render(request, 'profile/user.html', {
        'client': client,
        'reservations': reservations
    })
```

#### Добавление нового отеля
```python
# Добавление нового отеля через форму
@login_required
def add(request):
    if request.method == "POST":
        form = Add(request.POST)
        if form.is_valid():
            Hotel = form.save(commit=False)
            Hotel.owner = request.user
            Hotel.save()
            return redirect('hotel')
    else:
        form = Add()
    return render(request, 'product/add.html', {'form': form})
```

#### Отмена бронирования
```python
# Отмена бронирования с проверкой прав пользователя
@login_required
def cancel_booking(request, booking_id):
    try:
        reservation = Reservations.objects.get(id=booking_id, client_id=request.user.clients)
    except Reservations.DoesNotExist:
        messages.error(request, "Бронирование не найдено или у вас нет прав на его удаление.")
        return redirect('user_profile')
    if request.method == 'POST':
        reservation.delete()
        messages.success(request, "Бронирование успешно снято.")
        return redirect('user_profile')
    return render(request, 'product/cancel.html', {'reservation': reservation})
```

#### Удаление отеля
```python
# Удаление отеля с подтверждением
@login_required
def delete(request, id):
    hotel = get_object_or_404(Hotel, id=id)
    if request.method == "POST":
        hotel.delete()
        return redirect('hotel')
    return render(request, 'product/delete.html', {'hotel': hotel})
```

#### Редактирование информации об отеле
```python
# Редактирование данных отеля через форму
@login_required
def edit(request, id):
    hotel = get_object_or_404(Hotel, id=id)
    if request.method == "POST":
        form = Add(request.POST, instance=hotel)
        if form.is_valid():
            form.save()
            return redirect('hotel')
    else:
        form = Add(instance=hotel)
    return render(request, 'product/edit.html', {'form': form})
```

#### Удаление комментария с проверкой прав пользователя
```python
# Удаление комментария к отзыву с проверкой прав доступа
@login_required
def comment_delete(request, id):
    comment = get_object_or_404(Reviews_and_ratings, id=id)
    user = request.user
    if user.is_superuser or (hasattr(user, 'clients') and comment.client_id == user.clients):
        if request.method == "POST":
            hotel_id = comment.hotel_id.id
            comment.delete()
            messages.success(request, "Комментарий успешно удалён.")
            return redirect('hotel_info', id=hotel_id)
        else:
            return HttpResponseForbidden("Неверный метод запроса.")
    else:
        return HttpResponseForbidden("У вас нет прав на удаление этого комментария.")
```

#### Редактирование информации о комнате с проверкой прав доступа
```python
# Редактирование информации о комнате, доступно только для сотрудников
@login_required
def edit_room(request, hotel_id, room_number):
    if not request.user.is_staff:
        return HttpResponseForbidden("У вас нет прав на редактирование информации о комнате.")
    room = get_object_or_404(Room, hotel_id=hotel_id, room_number=room_number)
    if request.method == 'POST':
        form = RoomForm(request.POST, instance=room)
        if form.is_valid():
            form.save()
            messages.success(request, f"Информация о комнате №{room_number} успешно обновлена.")
            return redirect('hotel_info', id=hotel_id)
    else:
        form = RoomForm(instance=room)
    context = {
        'form': form,
        'hotel_id': hotel_id,
        'room_number': room_number,
    }
    return render(request, 'product/edit_room.html', context)
```

### &nbsp;

# <a name="forms.py">forms.py от Sergay</a> 

#### Импорт необходимых модулей и форм для создания пользовательских форм
```python
from django import forms
from .models import Hotel, Room
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.forms import AuthenticationForm
```

#### Форма для входа пользователя с полями для телефона или email и пароля
```python
class LoginForm(AuthenticationForm):
    username = forms.CharField(label='Телефон или Email')
    password = forms.CharField(label='Пароль', widget=forms.PasswordInput)
```

#### Форма регистрации пользователя с дополнительными полями профиля клиента
```python
class RegisterForm(UserCreationForm):
    phio = forms.CharField(label='ФИО', max_length=100, required=True)
    phone = forms.CharField(label='Телефон', max_length=11, required=True)
    email = forms.EmailField(label='Email', required=True)
    passport_seria = forms.IntegerField(label='Серия паспорта', required=True)
    passport_num = forms.IntegerField(label='Номер паспорта', required=True)

    class Meta(UserCreationForm.Meta):
        fields = ('username', 'email', 'password1', 'password2',
                 'phio', 'phone', 'passport_seria', 'passport_num')
```

#### Форма для добавления и редактирования информации об отеле
```python
class Add(forms.ModelForm):
    class Meta:
        model = Hotel
        fields = ['name', 'address', 'contact_phone', 'email', 'description', 'rating']
        labels = {
            "name": "Имя",
            "address": "Адрес",
            "contact_phone": "Контактный номер",
            "email": "Email",
            "description": "Описание",
            "rating": "Рейтинг",
        }
```

#### Форма для добавления и редактирования информации о комнате с множеством удобств
```python
class RoomForm(forms.ModelForm):
    class Meta:
        model = Room
        fields = [
            'room_number', 'type', 'minbar', 'conditioner', 'television', 'hairdryer', 'safe',
            'Kettle_or_coffee_maker', 'Sound_insulation', 'Balcony_or_terrace', 'special_for_ivalid',
            'Telephone', 'Fridge', 'Underfloor_heating', 'Work_facilities', 'Baby_cot_services', 'price'
        ]
        labels = {
            'room_number': 'Номер комнаты',
            'type': 'Тип комнаты',
            'minbar': 'Мини-Бар',
            'conditioner': 'Кондиционер',
            'television': 'Телевизор',
            'hairdryer': 'Фен',
            'safe': 'Сейф в номере',
            'Kettle_or_coffee_maker': 'Чайник или кофеварка',
            'Sound_insulation': 'Звукоизоляция',
            'Balcony_or_terrace': 'Балкон или терраса',
            'special_for_ivalid': 'Удобства для людей с ограниченными возможностями',
            'Telephone': 'Телефон',
            'Fridge': 'Холодильник',
            'Underfloor_heating': 'Пол с подогревом',
            'Work_facilities': 'Удобства для работы',
            'Baby_cot_services': 'Услуги по предоставлению детской кроватки',
            'price': 'Цена',
        }
```

### &nbsp;

# <a name="urls.py">Urls.py от Sergay</a> 

#### Импорт необходимых модулей и views для маршрутизации
```
from django.urls import path
from . import views
```

#### Определение маршрутов URL для различных страниц и действий
```python
urlpatterns = [
    path('', views.hotel, name='hotel'),  # Главная страница с отелями
    path('hotel/<int:id>/', views.hotel_info, name='hotel_info'),  # Информация об отеле по id
    path('booking/<int:id>/', views.booking, name='booking'),  # Бронирование отеля по id
    path('booking/<int:id>/<int:room_number>/', views.booking, name='booking'),  # Бронирование конкретной комнаты
    path('booking_info/<int:id>/', views.booking_info, name='booking_info'),  # Информация о бронировании
    path('login/', views.user_login, name='login'),  # Страница входа пользователя
    path('logout/', views.user_logout, name='logout'),  # Выход пользователя
    path('register/', views.register, name='register'),  # Регистрация нового пользователя
    path('profile/', views.user_profile, name='user_profile'),  # Профиль пользователя
    path('add/', views.add, name='add'),  # Добавление нового отеля
    path('delete/<int:id>/', views.delete, name='delete'),  # Удаление отеля по id
    path('edit/<int:id>/', views.edit, name='edit'),  # Редактирование отеля по id
    path('comment_delete/<int:id>/', views.comment_delete, name='comment_delete'),  # Удаление комментария по id
    path('cancel_booking/<int:booking_id>/', views.cancel_booking, name='cancel_booking'),  # Отмена бронирования по id
    path('hotel/<int:hotel_id>/room/<int:room_number>/edit/', views.edit_room, name='edit_room'),  # Редактирование комнаты
]
```

### &nbsp;

# <a name="admin.py">admin.py от Sergay</a> 

#### Импортируем необходимые модули и модели для регистрации в админке
```python
from django.contrib import admin
from .models import Hotel, Room, Clients, Reservations, Reviews_and_ratings
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User

```

#### Встраиваем модель Clients в админку пользователя для дополнительной информации
```python
class ClientsInline(admin.StackedInline):
    model = Clients
    can_delete = False
    verbose_name_plural = 'Дополнительная информация'
```

#### Кастомизация админки пользователя с добавлением ClientsInline
```python
class CustomUserAdmin(UserAdmin):
    inlines = (ClientsInline,)
```

#### Настройка отображения списка и полей модели Hotel в административной панели Django
```python
class HotelAdmin(admin.ModelAdmin):
    list_display = ('name', 'address', 'contact_phone', 'email', 'rating')
    fields = ('name', 'address', 'contact_phone', 'email', 'description', 'rating')
```
#### Регистрация моделей в админке и замена стандартного User на кастомный
```python
# Отменяем регистрацию стандартного User
admin.site.unregister(User)
# Регистрируем User с кастомным админом
admin.site.register(User, CustomUserAdmin)
# Регистрируем остальные модели для отображения в админке
admin.site.register(Clients)
admin.site.register(Hotel, HotelAdmin)
admin.site.register(Room)
admin.site.register(Reservations)
admin.site.register(Reviews_and_ratings)
```

### &nbsp;

### ER-диаграмма<a name="erd_diddy">![ERD](ERD.png)</a> 