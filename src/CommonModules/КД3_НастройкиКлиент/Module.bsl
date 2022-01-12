
Функция ЗначениеИзКэша(ИмяНастройки) Экспорт
	Возврат ПараметрыПриложения["КД3_Настройки_" + ИмяНастройки];
КонецФункции

Процедура ЗначениеВКэш(ИмяНастройки, ЗначениеНастройки) Экспорт
	ПараметрыПриложения.Вставить("КД3_Настройки_" + ИмяНастройки, ЗначениеНастройки);
КонецПроцедуры

Функция ИспользоватьРедакторКода() Экспорт
	Возврат ЗначениеИзКэша("ИспользоватьРедакторКода");
КонецФункции

Функция ИспользоватьКонтекстнуюПодсказку() Экспорт
	Возврат ЗначениеИзКэша("ИспользоватьКонтекстнуюПодсказку");
КонецФункции

Процедура СохранитьНастройкиВКэше(Настройки) Экспорт
	Для Каждого КлючИЗначение Из Настройки Цикл
		ЗначениеВКэш(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
КонецПроцедуры

Процедура ПередНачаломРаботыСистемы() Экспорт
	СохранитьНастройкиВКэше(КД3_Настройки.ЗагрузитьНастройки());
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы() Экспорт
	Если ЗначениеИзКэша("ИспользоватьРедакторКода") И ЗначениеИзКэша("УдалятьВременныеФайлыПриЗакрытии") Тогда
		КД3_РедакторКодаКлиент.УдалитьИсходники();
	КонецЕсли;
КонецПроцедуры
