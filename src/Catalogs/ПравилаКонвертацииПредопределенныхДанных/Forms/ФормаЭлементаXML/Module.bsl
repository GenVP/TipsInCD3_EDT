
&НаКлиенте
&После("ВыбранаКонвертация")
Процедура КД3_ВыбранаКонвертация(РезультатЗакрытия, ДополнительныеПараметры)
	// Обработка включения в состав конвертаций
	КД3_УправлениеФормойКлиент.ПриИзмененииКонвертаций(ЭтотОбъект, Ложь);
КонецПроцедуры

&НаКлиенте
&После("ВыбранОбъектКонфигурации")
Процедура КД3_ВыбранОбъектКонфигурации(РезультатЗакрытия, ДополнительныеПараметры)
	Если ДополнительныеПараметры = "ОбъектКонфигурацииКорреспондент" Тогда
		КД3_УправлениеФормойКлиент.ПриИзмененииОбъектаКонфигурации(ЭтотОбъект, Объект.ОбъектКонфигурацииКорреспондент, Ложь, Истина);
	Иначе
		КД3_УправлениеФормойКлиент.ПриИзмененииОбъектаКонфигурации(ЭтотОбъект, Объект.ОбъектКонфигурации, Ложь, Ложь);
	КонецЕсли;
КонецПроцедуры

#Область ПодключаемыеОбработчики

&НаКлиенте
Процедура КД3_Подключаемый_СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.ОбработчикиСобытий Тогда
		КД3_УправлениеФормойКлиент.ПриСменеСтраницы(ЭтотОбъект, Элементы.ОбработчикиXML.ТекущаяСтраница);
	КонецЕсли;
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура КД3_Подключаемый_ОбработчикиПриСменеСтраницы(Элемент, ТекущаяСтраница)
	КД3_УправлениеФормойКлиент.ПриСменеСтраницы(ЭтотОбъект, ТекущаяСтраница);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура КД3_Подключаемый_ПриИзмененииКонфигурации(Элемент)
	КД3_УправлениеФормойКлиент.ОчиститьМетаданныеКонфигурации(ЭтотОбъект, Ложь);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура КД3_Подключаемый_ПриИзмененииКонфигурацииКорреспондента(Элемент)
	КД3_УправлениеФормойКлиент.ОчиститьМетаданныеКонфигурации(ЭтотОбъект, Истина);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура КД3_Подключаемый_ДокументСформирован(Элемент)
	КД3_УправлениеФормойКлиент.ИнициализацияРедактора(ЭтотОбъект, Элемент.Имя, Объект);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ИнициализацияМетаданных() Экспорт
	КД3_УправлениеФормойКлиент.ИнициализацияМетаданных(ЭтотОбъект, Ложь);
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

&НаКлиенте
Процедура КД3_Подключаемый_ОбъектКонфигурацииПриИзменении(Элемент)
	КД3_УправлениеФормойКлиент.ПриИзмененииОбъектаКонфигурации(ЭтотОбъект, Объект.ОбъектКонфигурации, Ложь, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ОбъектКонфигурацииКорреспондентПриИзменении(Элемент)
	КД3_УправлениеФормойКлиент.ПриИзмененииОбъектаКонфигурации(ЭтотОбъект, Объект.ОбъектКонфигурацииКорреспондент, ЛОжь, Истина);
КонецПроцедуры

#КонецОбласти

#Область ЗаменяемыеОбработчики

//@skip-warning
&НаСервере
Процедура КД3_Подключаемый_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	ПриСозданииНаСервере(Отказ, СтандартнаяОбработка); // Типовой
	
	Обработчики = Новый СписокЗначений;
	Обработчики.Добавить("АлгоритмПередВыгрузкойОбъекта");
	Обработчики.Добавить("АлгоритмПриВыгрузкеОбъекта");
	Обработчики.Добавить("АлгоритмПослеВыгрузкиОбъекта");
	Обработчики.Добавить("АлгоритмПослеВыгрузкиОбъектаВФайлОбмена");
	Обработчики.Добавить("АлгоритмПередЗагрузкойОбъекта", , Истина);
	Обработчики.Добавить("АлгоритмПриЗагрузкеОбъекта", , Истина);
	Обработчики.Добавить("АлгоритмПослеЗагрузкиОбъекта", , Истина);
	КД3_УправлениеФормой.ПриСозданииНаСервере(ЭтотОбъект, Отказ, Ложь, "ПКПД", Обработчики, Элементы.ОбработчикиXML);
	
	УстановитьДействие("ПередЗаписью", "КД3_Подключаемый_ПередЗаписьюПосле");
	УстановитьДействие("ПриЗакрытии", "КД3_Подключаемый_ПриЗакрытииПосле");
	УстановитьДействие("ОбработкаВыбора", "КД3_Подключаемый_ОбработкаВыбора");
	Элементы.Страницы.УстановитьДействие("ПриСменеСтраницы", "КД3_Подключаемый_СтраницыПриСменеСтраницы");
	Элементы.ОбъектКонфигурации.УстановитьДействие("ПриИзменении", "КД3_Подключаемый_ОбъектКонфигурацииПриИзменении");
	Элементы.ОбъектКонфигурацииКорреспондент.УстановитьДействие("ПриИзменении", "КД3_Подключаемый_ОбъектКонфигурацииКорреспондентПриИзменении");
	
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
Процедура КД3_Подключаемый_ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора); // Типовой
	// Обработка исключения из состава конвертаций
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		КД3_УправлениеФормойКлиент.ПриИзмененииКонвертаций(ЭтотОбъект, Ложь);
	КонецЕсли;
КонецПроцедуры

#Если Сервер Тогда
КД3_УправлениеФормой.ПриПервомОткрытииФормы(ЭтотОбъект);
#КонецЕсли

#КонецОбласти
