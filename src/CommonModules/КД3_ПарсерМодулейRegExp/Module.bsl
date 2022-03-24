#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьМетодыМодуля(ДанныеМодуля, ПолноеИмяФайла, ПараметрыЗагрузки) Экспорт
	
	ПодключитьВычислитель(ПараметрыЗагрузки);
	
	КД3_Вычислитель = ПараметрыЗагрузки.КД3_Вычислитель;
	
	ЧтениеТекста = Новый ЧтениеТекста(ПолноеИмяФайла, "UTF-8",,, Ложь);
	ТекстМодуля = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	
	Выражение = "^(?<directive0>^&[А-Яа-я\w]*\s*)?\s*(?<comment>(?:^[^\n\S]*\/\/[^\r\n]*\n)*)\s*(?<directive1>^&[А-Яа-я\w]*\s*)?(?<type>процедура|функция)\s+(?<name>[А-Яа-я\w]+)\s*\((?<params>[^)]*)\)\s*(?<export>экспорт)";
	Совпадения = ВычислительНайтиСовпадения(КД3_Вычислитель, ТекстМодуля, Выражение, "Директива0,Описание,Директива1,Тип,Имя,Параметры,Экспорт");
	
	Для Каждого Совпадение Из Совпадения Цикл
		ОписаниеМетода = Совпадение.Описание;
		ВыделитьБлокОписания(КД3_Вычислитель, ОписаниеМетода, "Пример");
		ВыделитьБлокОписания(КД3_Вычислитель, ОписаниеМетода, "Возвращаемое значение");
		ОписаниеПараметры = ВыделитьБлокОписания(КД3_Вычислитель, ОписаниеМетода, "Параметры");
		ОписаниеМетода = УдалитьСлешиИзКомментария(КД3_Вычислитель, ОписаниеМетода);
		
		СтруктураПараметров = Новый Структура;
		
		ЗаполнитьПараметрыМетодаПоЗаголовку(КД3_Вычислитель, СтруктураПараметров, Совпадение.Параметры);
		ЗаполнитьПараметрыМетодаПоОписанию(КД3_Вычислитель, СтруктураПараметров, ОписаниеПараметры);
		
		ДанныеМетода = Новый Структура;
		ДанныеМетода.Вставить("name", Совпадение.Имя);
		ДанныеМетода.Вставить("name_en", Совпадение.Имя);
		ДанныеМетода.Вставить("description", УдалитьСлешиИзКомментария(КД3_Вычислитель, Совпадение.Описание));
		ДанныеМетода.Вставить("detail", ОписаниеМетода);
		ДанныеМетода.Вставить("returns", "");
		ДанныеМетода.Вставить("signature", Новый Структура("default", Новый Структура));
		
		ДанныеМетода.signature.default.Вставить("СтрокаПараметров", "(" + Совпадение.Параметры + ")");
		ДанныеМетода.signature.default.Вставить("Параметры", СтруктураПараметров);
		
		ДанныеМодуля.module.Вставить(Совпадение.Имя, ДанныеМетода);
	КонецЦикла;
	
	ДанныеМодуля.count = ДанныеМодуля.module.Количество();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПодключитьВычислитель(ПараметрыЗагрузки)
	
	КД3_Вычислитель = Неопределено;
	Если ПараметрыЗагрузки.Свойство("КД3_Вычислитель", КД3_Вычислитель) Тогда
		Возврат;
	КонецЕсли;
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	
	Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86 Тогда
		Платформа = "Lin";
		Разрядность = "32";
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
		Платформа = "Lin";
		Разрядность = "64";
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86 Тогда
		Платформа = "Win";
		Разрядность = "32";
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		Платформа = "Win";
		Разрядность = "64";
	Иначе
		ВызватьИсключение "Не поддерживаемый тип платформы";
	КонецЕсли;
	Местоположение = "ОбщийМакет.КД3_RegEx" + Платформа + Разрядность;
	
	ПодключитьВнешнююКомпоненту(Местоположение, "ВычислительРегВыражений", ТипВнешнейКомпоненты.Native);
	КД3_Вычислитель = Новый("AddIn.ВычислительРегВыражений.RegEx");
	
	КД3_Вычислитель.IgnoreCase = Истина;
	КД3_Вычислитель.Global = Истина;
	КД3_Вычислитель.MultiLine = Истина;
	
	ПараметрыЗагрузки.Вставить("КД3_Вычислитель", КД3_Вычислитель);
	
КонецПроцедуры

Функция ВычислительНайтиСовпадения(КД3_Вычислитель, Текст, Выражение, ИменаГрупп)
	
	МассивГрупп = СтрРазделить(ИменаГрупп, ",", Ложь);
	
	ТекстJSON = КД3_Вычислитель.MatchesJSON(Текст, Выражение);
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ТекстJSON);
	СовпаденияJSON = ПрочитатьJSON(ЧтениеJSON, Ложь);
	ЧтениеJSON.Закрыть();
	
	Совпадения = Новый Массив;
	Для Каждого СовпадениеJSON Из СовпаденияJSON Цикл
		Совпадение = Новый Структура;
		Если МассивГрупп.Количество() = 0 Тогда
			Совпадение.Вставить("Индекс", СовпадениеJSON.FirstIndex);
			Совпадение.Вставить("Текст", СовпадениеJSON.Value);
		Иначе
			Индекс = 0;
			Для Каждого ЗначениеГруппы Из СовпадениеJSON.SubMatches Цикл
				Совпадение.Вставить(МассивГрупп[Индекс], ЗначениеГруппы);
				Индекс = Индекс + 1;
			КонецЦикла;
		КонецЕсли;
		Совпадения.Добавить(Совпадение);
	КонецЦикла;
	
	Возврат Совпадения;
	
КонецФункции

Функция ВыделитьБлокОписания(КД3_Вычислитель, ОписаниеМетода, ИмяБлока)
	
	Если ПустаяСтрока(ОписаниеМетода) Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяБлокаРег = СтрЗаменить(НРег(ИмяБлока), " ", "\s+");
	Выражение = СтрЗаменить("^\s*\/\/\s*ИмяБлока\s*[:][\s\S]*", "ИмяБлока", ИмяБлокаРег);
	
	Совпадения = ВычислительНайтиСовпадения( КД3_Вычислитель, ОписаниеМетода, Выражение, "");
	Если Совпадения.Количество() <> 1 Тогда
		Возврат "";
	КонецЕсли;
	
	ОписаниеМетода = Лев(ОписаниеМетода, Совпадения[0].Индекс);
	
	Возврат УдалитьСлешиИзКомментария(КД3_Вычислитель, Совпадения[0].Текст);
	
КонецФункции

Процедура ЗаполнитьПараметрыМетодаПоОписанию(КД3_Вычислитель, СтруктураПараметров, ОписаниеПараметры)
	
	Если СтруктураПараметров.Количество() = 0 ИЛИ ПустаяСтрока(ОписаниеПараметры) Тогда
		Возврат;
	КонецЕсли;
	
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Имя");
	ТЗ.Колонки.Добавить("Индекс");
	
	Для Каждого КлючИЗначение Из СтруктураПараметров Цикл
		Выражение = СтрЗаменить("^[\s]*Параметр\s*[-–]\s*\S*\s*[-–]", "Параметр", КлючИЗначение.Ключ);
		Совпадения = ВычислительНайтиСовпадения(КД3_Вычислитель, ОписаниеПараметры, Выражение, "");
		Если Совпадения.Количество() = 1 Тогда
			СтрокаТЗ = ТЗ.Добавить();
			СтрокаТЗ.Имя = КлючИЗначение.Ключ;
			СтрокаТЗ.Индекс = Совпадения[0].Индекс;
		КонецЕсли;
	КонецЦикла;
	ТЗ.Сортировать("Индекс");
	
	ИндексСтроки = 0;
	КоличествоСтрок = ТЗ.Количество();
	Пока ИндексСтроки < КоличествоСтрок Цикл
		СтрокаТЗ = ТЗ[ИндексСтроки];
		ИндексСтроки = ИндексСтроки + 1;
		Если ИндексСтроки = КоличествоСтрок Тогда
			ОписаниеПараметра = Сред(ОписаниеПараметры, СтрокаТЗ.Индекс);
		Иначе
			ОписаниеПараметра = Сред(ОписаниеПараметры, СтрокаТЗ.Индекс, ТЗ[ИндексСтроки].Индекс  - СтрокаТЗ.Индекс);
		КонецЕсли;
		СтруктураПараметров.Вставить(СтрокаТЗ.Имя, СокрЛ(ОписаниеПараметра));
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыМетодаПоЗаголовку(КД3_Вычислитель, СтруктураПараметров, СтрокаПараметров)
	
	Если СтрокаПараметров = Неопределено Тогда
		Возврат;
	КонецЕсли;
	//TODO: Обрабатывать возможные комментарии в параметрах методов в заголовке
	Выражение = "[знач]?([А-Яа-я\w]+)\s*(?:=\s*[^,]*)?,";
	Совпадения = ВычислительНайтиСовпадения(КД3_Вычислитель, СтрокаПараметров + ",", Выражение, "Имя");
	Для Каждого Совпадение Из Совпадения Цикл
		СтруктураПараметров.Вставить(Совпадение.Имя, "");
	КонецЦикла;
	
КонецПроцедуры

Функция УдалитьСлешиИзКомментария(КД3_Вычислитель, ТекстКомментария)
	Возврат КД3_Вычислитель.Заменить(ТекстКомментария, "(^\s*\/\/\s{0,2})", "");
КонецФункции

#КонецОбласти