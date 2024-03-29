
#Область ПодключаемыеОбработчики

&НаКлиенте
Процедура КД3_Подключаемый_СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.СтраницаКонвертацияXDTO Тогда
		КД3_Подключаемый_ГруппаДанныеКонвертацииXDTOПриСменеСтраницы(, Элементы.ГруппаДанныеКонвертацииXDTO.ТекущаяСтраница)
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаКонвертацияXML Тогда
		КД3_УправлениеФормойКлиент.ПриСменеСтраницы(ЭтотОбъект, Элементы.ОбработчикиXML.ТекущаяСтраница);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ГруппаДанныеКонвертацииXDTOПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.СтраницаОбработчики Тогда
		КД3_УправлениеФормойКлиент.ПриСменеСтраницы(ЭтотОбъект, Элементы.СтраницыОбработчики.ТекущаяСтраница);
	КонецЕсли;
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура КД3_Подключаемый_ОбработчикиПриСменеСтраницы(Элемент, ТекущаяСтраница)
	КД3_УправлениеФормойКлиент.ПриСменеСтраницы(ЭтотОбъект, ТекущаяСтраница);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура КД3_Подключаемый_ДокументСформирован(Элемент);
	КД3_УправлениеФормойКлиент.ИнициализацияРедактора(ЭтотОбъект, Элемент.Имя, Объект);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ИнициализацияМетаданных() Экспорт
	ИзмененныйКонтекст = КД3_ЗаполнитьИзмененныйКонтекст_Параметры(ИзмененныйКонтекст);
	КД3_УправлениеФормойКлиент.ИнициализацияМетаданных(ЭтотОбъект, КонвертацияXDTO, ИзмененныйКонтекст);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура КД3_Подключаемый_HTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	КД3_УправлениеФормойКлиент.ОбработатьСобытиеHTML(ЭтотОбъект, Элемент, ДанныеСобытия);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура КД3_Подключаемый_КомандаРедактора(Команда)
	КД3_УправлениеФормойКлиент.КомандаРедактора(ЭтотОбъект, Команда);
КонецПроцедуры

#КонецОбласти

#Область ЗаменяемыеОбработчики

//@skip-warning
&НаСервере
Процедура КД3_Подключаемый_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	ПриСозданииНаСервере(Отказ, СтандартнаяОбработка); // Типовой
	
	Обработчики = Новый СписокЗначений;
	
	Если КонвертацияXDTO Тогда
		Обработчики.Добавить("АлгоритмПередКонвертацией");
		Обработчики.Добавить("АлгоритмПередОтложеннымЗаполнением");
		Обработчики.Добавить("АлгоритмПослеКонвертации");
		СтраницыОбработчиков = Элементы.СтраницыОбработчики;
	Иначе
		Обработчики.Добавить("АлгоритмПослеЗагрузкиПравилОбмена");
		Обработчики.Добавить("АлгоритмПередВыгрузкойДанных");
		Обработчики.Добавить("АлгоритмПередПолучениемИзмененныхОбъектов");
		Обработчики.Добавить("АлгоритмПередВыгрузкойОбъекта");
		Обработчики.Добавить("АлгоритмПередОтправкойИнформацииОбУдалении");
		Обработчики.Добавить("АлгоритмПередКонвертациейОбъекта");
		Обработчики.Добавить("АлгоритмПослеВыгрузкиОбъекта");
		Обработчики.Добавить("АлгоритмПослеВыгрузкиДанных");
		Обработчики.Добавить("АлгоритмПередЗагрузкойДанных", , Истина);
		Обработчики.Добавить("АлгоритмПослеЗагрузкиПараметров", , Истина);
		Обработчики.Добавить("АлгоритмПослеПолученияИнформацииОбУзлахОбмена", , Истина);
		Обработчики.Добавить("АлгоритмПередЗагрузкойОбъекта", , Истина);
		Обработчики.Добавить("АлгоритмПриПолученииИнформацииОбУдалении", , Истина);
		Обработчики.Добавить("АлгоритмПослеЗагрузкиОбъекта", , Истина);
		Обработчики.Добавить("АлгоритмПослеЗагрузкиДанных", , Истина);
		СтраницыОбработчиков = Элементы.ОбработчикиXML;
	КонецЕсли;
	КД3_УправлениеФормой.ПриСозданииНаСервере(ЭтотОбъект, Отказ, КонвертацияXDTO, "Конвертация", Обработчики, СтраницыОбработчиков);
	
	УстановитьДействие("ПриОткрытии", "КД3_Подключаемый_ПриОткрытииПосле");
	УстановитьДействие("ПередЗаписью", "КД3_Подключаемый_ПередЗаписьюПосле");
	УстановитьДействие("ПриЗакрытии", "КД3_Подключаемый_ПриЗакрытииПосле");
	Элементы.Конфигурация.УстановитьДействие("ПриИзменении", "КД3_Подключаемый_КонфигурацияПриИзмененииПосле");
	Элементы.КонфигурацияИсточник.УстановитьДействие("ПриИзменении", "КД3_Подключаемый_КонфигурацияИсточникПриИзмененииПосле");
	Элементы.КонфигурацияКорреспондент.УстановитьДействие("ПриИзменении", "КД3_Подключаемый_КонфигурацияКорреспондентПриИзмененииПосле");
	Элементы.Параметры.УстановитьДействие("ПриИзменении", "КД3_Подключаемый_ПараметрыПриИзмененииПосле");
	Элементы.Страницы.УстановитьДействие("ПриСменеСтраницы", "КД3_Подключаемый_СтраницыПриСменеСтраницы");
	Элементы.ГруппаДанныеКонвертацииXDTO.УстановитьДействие("ПриСменеСтраницы", "КД3_Подключаемый_ГруппаДанныеКонвертацииXDTOПриСменеСтраницы");
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ПриОткрытииПосле(Отказ)
	ПриОткрытии(Отказ); // Типовой
	Если НЕ КонвертацияXDTO Тогда
		КД3_УправлениеФормойКлиент.ПриСменеСтраницы(ЭтотОбъект, Элементы.ОбработчикиXML.ТекущаяСтраница);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ПередЗаписьюПосле(Отказ, ПараметрыЗаписи)
	КД3_УправлениеФормойКлиент.ПередЗаписью(ЭтотОбъект, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ПриЗакрытииПосле(ЗавершениеРаботы) Экспорт
	КД3_УправлениеФормойКлиент.ПриЗакрытии(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_КонфигурацияПриИзмененииПосле(Элемент)
	ЭтотОбъект.КД3_Конфигурация = Объект.Конфигурация;
	КД3_УправлениеФормойКлиент.ОчиститьМетаданныеКонфигурации(ЭтотОбъект, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_КонфигурацияИсточникПриИзмененииПосле(Элемент)
	ЭтотОбъект.КД3_Конфигурация = Объект.Конфигурация;
	КД3_УправлениеФормойКлиент.ОчиститьМетаданныеКонфигурации(ЭтотОбъект, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_КонфигурацияКорреспондентПриИзмененииПосле(Элемент)
	ЭтотОбъект.КД3_КонфигурацияКорреспондент = Объект.КонфигурацияКорреспондент;
	КД3_УправлениеФормойКлиент.ОчиститьМетаданныеКонфигурации(ЭтотОбъект, Истина);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ПараметрыПриИзмененииПосле(Элемент)
	ИзмененныйКонтекст = КД3_ЗаполнитьИзмененныйКонтекст_Параметры(ИзмененныйКонтекст);
	КД3_УправлениеФормойКлиент.ОбновитьЛокальныйКонтекст(ЭтотОбъект, КонвертацияXDTO, ИзмененныйКонтекст);
КонецПроцедуры

&НаКлиенте
Функция КД3_ЗаполнитьИзмененныйКонтекст_Параметры(ИзмененныйКонтекст)
	ИзмененныйКонтекст = Новый Структура;
	ИзмененныйКонтекст.Вставить("ПараметрыКонвертации", Новый СписокЗначений);
	Для Каждого СтрокаПараметра Из Объект.Параметры Цикл
		ИзмененныйКонтекст.ПараметрыКонвертации.Добавить(СтрокаПараметра.Параметр,, СтрокаПараметра.ИспользуетсяПриЗагрузке И НЕ СтрокаПараметра.ПередаватьПараметрПриВыгрузке);
	КонецЦикла;
	Возврат ИзмененныйКонтекст;
КонецФункции

#Если Сервер Тогда
КД3_УправлениеФормой.ПриПервомОткрытииФормы(ЭтотОбъект);
#КонецЕсли

#КонецОбласти
