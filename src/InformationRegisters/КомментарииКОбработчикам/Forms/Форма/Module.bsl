
&НаСервере
Процедура КД3_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	// Открытие формы из контекстного меню
	Если Параметры.Свойство("КД3_ВидОбработчика") Тогда
		ВидОбработчика = Параметры.КД3_ВидОбработчика;
		ВидОбработчикаПриИзмененииНаСервере();
	КонецЕсли;
КонецПроцедуры
