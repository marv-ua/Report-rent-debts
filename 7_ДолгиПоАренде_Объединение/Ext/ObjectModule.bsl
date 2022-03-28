﻿
Функция СведенияОВнешнейОбработке() Экспорт 
    
    ИмяОтчета = ЭтотОбъект.Метаданные().Имя; 
    Синоним = ЭтотОбъект.Метаданные().Синоним; 
    Синоним = ?(ЗначениеЗаполнено(Синоним),Синоним, ИмяОтчета); 
    РегистрационныеДанные = Новый Структура();
    РегистрационныеДанные.Вставить("Вид", "ДополнительныйОтчет");
    РегистрационныеДанные.Вставить("Наименование", Синоним);
    РегистрационныеДанные.Вставить("Версия", "1.0");
    РегистрационныеДанные.Вставить("БезопасныйРежим", Ложь);
    РегистрационныеДанные.Вставить("Информация", ""+ЭтотОбъект.Метаданные().Комментарий);
        
    ТаблицаКоманд = ПолучитьТаблицуКоманд();

    // Добавим команду в таблицу
    ДобавитьКоманду(ТаблицаКоманд, Синоним, "1" , "ОткрытиеФормы", Истина, );
        
       // Сохраним таблицу команд в параметры регистрации обработки
    РегистрационныеДанные.Вставить("Команды", ТаблицаКоманд);

    Возврат РегистрационныеДанные;

КонецФункции

Функция ПолучитьТаблицуКоманд()
    
    // Создадим пустую таблицу команд и колонки в ней
    Команды = Новый ТаблицаЗначений;

    // Как будет выглядеть описание печатной формы для пользователя
    Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка")); 

    // Имя нашего макета, что бы могли отличить вызванную команду в обработке печати
    Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));

    // Тут задается, как должна вызваться команда обработки
    // Возможные варианты:
    // - ОткрытиеФормы - в этом случае в колонке идентификатор должно быть указано имя формы, которое должна будет открыть система
    // - ВызовКлиентскогоМетода - вызвать клиентскую экспортную процедуру из модуля формы обработки
    // - ВызовСерверногоМетода - вызвать серверную экспортную процедуру из модуля объекта обработки
    Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));

    // Следующий параметр указывает, необходимо ли показывать оповещение при начале и завершению работы обработки. Не имеет смысла при открытии формы
    Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));

    // Для печатной формы должен содержать строку ПечатьMXL 
    Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
    Возврат Команды;
   
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование = "ОткрытиеФормы", ПоказыватьОповещение = Ложь, Модификатор)
    
    // Добавляем команду в таблицу команд по переданному описанию.
    // Параметры и их значения можно посмотреть в функции ПолучитьТаблицуКоманд
    НоваяКоманда = ТаблицаКоманд.Добавить();
    НоваяКоманда.Представление = Представление;
    НоваяКоманда.Идентификатор = Идентификатор;
    НоваяКоманда.Использование = Использование;
    НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
    НоваяКоманда.Модификатор = Модификатор;

КонецПроцедуры 

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
    СтандартнаяОбработка = Ложь;
    КомпоновщикМакет = Новый КомпоновщикМакетаКомпоновкиДанных;
    Макет = КомпоновщикМакет.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
    ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновки.Инициализировать(Макет, , ДанныеРасшифровки, Истина);
    ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	КоличествоУровней = ДокументРезультат.КоличествоУровнейГруппировокСтрок();
	Для Уровень = 1 По КоличествоУровней - 2 Цикл
		ДокументРезультат.ПоказатьУровеньГруппировокСтрок(КоличествоУровней - Уровень);
	КонецЦикла;
//	ТекОрганизация=СокрЛП(Макет.ЗначенияПараметров.Организация.Значение);
//	ДокументРезультат.Записать("D:\analiz"+ТекОрганизация+".xls",ТипФайлаТабличногоДокумента.XLS);
	
КонецПроцедуры