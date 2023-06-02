
Процедура ИзвлечьИсходники() Экспорт
	
	КаталогИсходников = КД3_НастройкиКлиент.ЗначениеИзКэша("КаталогИсходников");
	Если КаталогИсходников <> Неопределено Тогда
		Возврат;
	КонецЕсли;
#Если НЕ ВебКлиент Тогда
	ЭтоЛинуксКлиент = ОбщегоНазначенияКлиент.ЭтоLinuxКлиент();
	ВерсияРедактораКода = КД3_Настройки.ВерсияКонсолиКода(ЭтоЛинуксКлиент);
	КаталогИсходников = КаталогВременныхФайлов() + ВерсияРедактораКода.ПодкаталогИсходников + ПолучитьРазделительПутиКлиента();
	
	// Проверка индексного файла с текущей версией консоли кода
	ИмяИндексногоФайла = КаталогИсходников + "cd3_" + ВерсияРедактораКода.Версия + ".id";   
	ТестФайл = Новый Файл(ИмяИндексногоФайла);
	Если НЕ ТестФайл.Существует() Тогда
		СоздатьКаталог(КаталогИсходников);
		УдалитьФайлы(КаталогИсходников, "*.*");
		//  Извлечение файлов новой версии
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(КД3_Настройки.ДвоичныеДанныеКонсолиКода(ЭтоЛинуксКлиент));
		ZipФайл = Новый ЧтениеZipФайла(ДвоичныеДанные.ОткрытьПотокДляЧтения());
		ZipФайл.ИзвлечьВсе(КаталогИсходников);
		ДобавитьМетодыВИсходники(КаталогИсходников, ЭтоЛинуксКлиент);
		// Создание индексного файла
		ЗаписьТекста = Новый ЗаписьТекста(ИмяИндексногоФайла);
		ЗаписьТекста.Закрыть();
	КонецЕсли;
	
	КД3_НастройкиКлиент.ЗначениеВКэш("КаталогИсходников", КаталогИсходников);
#КонецЕсли
	
КонецПроцедуры

Функция ПутьРедактораКода() Экспорт
	
	Возврат КД3_НастройкиКлиент.ЗначениеИзКэша("КаталогИсходников") + ПолучитьРазделительПутиКлиента() + "index.html";
	
КонецФункции

Процедура УдалитьИсходники() Экспорт
	
	КаталогИсходников = КД3_НастройкиКлиент.ЗначениеИзКэша("КаталогИсходников");
	Если КаталогИсходников = Неопределено Тогда
		Возврат;
	КонецЕсли;
	УдалитьФайлы(КаталогИсходников);
	КД3_НастройкиКлиент.ЗначениеВКэш("КаталогИсходников", Неопределено);
	
КонецПроцедуры

Процедура ИнициализацияРедактора(Форма, ИмяРеквизита, ТекстОбработчика, ТолькоПросмотр) Экспорт
	
	ДокView = View(Форма, ИмяРеквизита);
	Если ДокView = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		Инфо = Новый СистемнаяИнформация;
		ДокView.init(Инфо.ВерсияПриложения);
		ДокView.setOption("autoResizeEditorLayout", Истина);
		ДокView.setOption("renderQueryDelimiters", Истина);
		ДокView.hideScrollX();
		ДокView.hideScrollY();
		
		Если НЕ КД3_НастройкиКлиент.ЗначениеИзКэша("ОтображатьНомераСтрок") Тогда
			ДокView.hideLineNumbers();
		КонецЕсли;
		
		Тема = КД3_НастройкиКлиент.ЗначениеИзКэша("Тема");
		Если КД3_НастройкиКлиент.ЗначениеИзКэша("ПодсветкаЯзыкаЗапросов") Тогда
			Тема = Тема + "-query";
		КонецЕсли;
		Форма.Элементы[ИмяРеквизита].Документ.monaco.editor.setTheme(Тема);
		
		ДокView.disableContextMenu();
		ДокView.minimap(КД3_НастройкиКлиент.ЗначениеИзКэша("ОтображатьКартуКода"));
		
		ДокView.setText(ТекстОбработчика);
		
		Если ТолькоПросмотр Тогда
			ДокView.setReadOnly(Истина);
		Иначе
			ДокView.setOption("generateModificationEvent", Истина);
		КонецЕсли;
		
		Если КД3_НастройкиКлиент.ИспользоватьКонтекстнуюПодсказку() Тогда
			Форма.КД3_Инициализация.Добавить(ИмяРеквизита);
			Форма.ПодключитьОбработчикОжидания("КД3_Подключаемый_ИнициализацияМетаданных", 0.5, Истина);
		КонецЕсли;
	Исключение
		ТекстСообщения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецПопытки;
	
КонецПроцедуры

Процедура ИнициализацияМетаданных(Форма, ЭтоКонвертацияXDTO, ИзмененныйКонтекст = Неопределено) Экспорт
	
	ОписаниеЛокальногоКонтекста = КД3_МетаданныеКлиент.ОписаниеЛокальногоКонтекста(Форма, ЭтоКонвертацияXDTO, ИзмененныйКонтекст);
	
	Пока Форма.КД3_Инициализация.Количество() > 0 Цикл
		ИмяРеквизита = Форма.КД3_Инициализация[0].Значение;
		ИмяОбработчика = Сред(ИмяРеквизита, 5);
		ДляКорреспондента = Форма.КД3_Обработчики.НайтиПоЗначению(ИмяОбработчика).Пометка;
		Если ДляКорреспондента Тогда
			Конфигурация = Форма.КД3_КонфигурацияКорреспондент;
		Иначе
			Конфигурация = Форма.КД3_Конфигурация;
		КонецЕсли;
		Форма.КД3_Инициализация.Удалить(0);
		
		Если НЕ ЗначениеЗаполнено(Конфигурация) Тогда
			Продолжить;
		КонецЕсли;
		
		ДокView = View(Форма, ИмяРеквизита);
		Если ДокView = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ДокView.clearMetadata();
		
		ОписаниеКонтекста = КД3_МетаданныеКлиент.ОписаниеМетаданных(Конфигурация, "globalcontext");
		
		// Загрузка списка всех общих модулей (без методов)
		Если ОписаниеКонтекста.ОбщиеМодули <> Неопределено Тогда
			Результат = ДокView.updateMetadataObj(ОписаниеКонтекста.ОбщиеМодули);
			Если НЕ ПустаяСтрока(Результат) Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю("Ошибка загрузки общих модулей: " + Результат);
			КонецЕсли;
		КонецЕсли;
		// Загрузка методов глобальных общих модулей
		Если ОписаниеКонтекста.ГлобальныеМодули <> Неопределено Тогда
			ТекстОшибки = ДокView.updateMetadataModule(ОписаниеКонтекста.ГлобальныеМодули);
			Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю("Ошибка загрузки методов глобальных модулей: " + ТекстОшибки);
			КонецЕсли;
		КонецЕсли;
		
		// Загрузка объектов локального контекста
		Если ОписаниеЛокальногоКонтекста <> Неопределено Тогда
			ПеременныеJSON = ОписаниеЛокальногоКонтекста["Переменные"][ДляКорреспондента]; // Общие переменные
			МетодыJSON = ОписаниеЛокальногоКонтекста["Методы"];
			ПеременныеОбработчика = ОписаниеЛокальногоКонтекста[ИмяОбработчика];
			Если ПеременныеОбработчика <> Неопределено Тогда
				// Объединение общих переменных и переменных обработчика
				ПеременныеJSON = Лев(ПеременныеJSON, СтрДлина(ПеременныеJSON) - 1) + "," + Сред(ПеременныеОбработчика, 2);
			КонецЕсли;
			
			ТекстОшибки = ДокView.updateMetadata("{""customObjects"":" + ПеременныеJSON + "}");
			Если ТипЗнч(ТекстОшибки) <> Тип("Булево") Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю("Ошибка загрузки объектов локального контекста: " + ТекстОшибки);
			КонецЕсли;
			Если МетодыJSON <> Неопределено Тогда
				ТекстОшибки = ДокView.updateCustomFunctions("{""customFunctions"":" + МетодыJSON + "}");
				Если ТипЗнч(ТекстОшибки) <> Тип("Булево") Тогда
					ОбщегоНазначенияКлиент.СообщитьПользователю("Ошибка загрузки методов локального контекста: " + ТекстОшибки);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьЛокальныйКонтекст(Форма, ЭтоКонвертацияXDTO, ИзмененныйКонтекст) Экспорт
	
	ОписаниеЛокальногоКонтекста = КД3_МетаданныеКлиент.ОбновитьЛокальныйКонтекст(Форма, ЭтоКонвертацияXDTO, ИзмененныйКонтекст);
	
	// Загрузка измененных объектов локального контекста
	Для Каждого ЭлементСписка Из Форма.КД3_Обработчики Цикл
		ИмяОбработчика = ЭлементСписка.Значение;
		ДляКорреспондента = ЭлементСписка.Пометка;
		ИмяРеквизита = "КД3_" + ИмяОбработчика;
		Если Форма.КД3_Инициализация.НайтиПоЗначению(ИмяРеквизита) <> Неопределено Тогда
			Продолжить; // Метаданные обработчика еще не инициализированы
		КонецЕсли;
		ДокView = View(Форма, ИмяРеквизита);
		Если ДокView = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		// Объединение общих переменных и переменных обработчика
		ПеременныеJSON = ОписаниеЛокальногоКонтекста["Переменные"][ДляКорреспондента]; // Общие переменные
		ПеременныеОбработчика = ОписаниеЛокальногоКонтекста[ИмяОбработчика];
		Если ПеременныеОбработчика <> Неопределено Тогда
			ПеременныеJSON = Лев(ПеременныеJSON, СтрДлина(ПеременныеJSON) - 1) + "," + Сред(ПеременныеОбработчика, 2);
		КонецЕсли;
		ТекстОшибки = ДокView.updateMetadata("{""customObjects"":" + ПеременныеJSON + "}");
		Если ТипЗнч(ТекстОшибки) <> Тип("Булево") Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю("Ошибка загрузки объектов локального контекста: " + ТекстОшибки);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьТекстПриТолькоПросмотр(Форма, ИмяОбработчика) Экспорт
	View(Форма, "КД3_" + ИмяОбработчика).updateText(Форма[ИмяОбработчика]);
КонецПроцедуры

Процедура УстановитьТекст(Форма, ИмяРеквизита, Текст, Позиция = Неопределено, УчитыватьОтступПервойСтроки = Ложь) Экспорт
	View(Форма, ИмяРеквизита).setText(Текст, Позиция);
КонецПроцедуры

Функция ПолучитьТекст(Форма, ИмяРеквизита) Экспорт
	Возврат View(Форма, ИмяРеквизита).getText();
КонецФункции

Процедура ОчиститьМетаданные(Форма, ИмяРеквизита) Экспорт
	ДокView = View(Форма, ИмяРеквизита);
	Если ДокView <> Неопределено Тогда
		ДокView.clearMetadata();
	КонецЕсли;
КонецПроцедуры

Функция ОбновитьСписокМетаданных(Форма, ИмяРеквизита, ОписанияМетаданных) Экспорт
	
	ДокView = View(Форма, ИмяРеквизита);
	
	ТекстОшибки = Новый Массив;
	Для Каждого КлючИЗначение Из ОписанияМетаданных Цикл
		Если КлючИЗначение.Значение = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ЭтоМодуль = СтрНачинаетсяС(КлючИЗначение.Ключ, "module");
		Если ЭтоМодуль Тогда
			РезультатОбновления = ДокView.updateMetadataModule(КлючИЗначение.Значение);
		Иначе
			РезультатОбновления = ДокView.updateMetadataObj(КлючИЗначение.Значение);
		КонецЕсли;
		Если НЕ ПустаяСтрока(РезультатОбновления) Тогда
			ТекстОшибки.Добавить(РезультатОбновления);
		КонецЕсли;
	КонецЦикла;
	
	ДокView.triggerSuggestions();
	
	Возврат СтрСоединить(ТекстОшибки, Символы.ПС);
	
КонецФункции

Процедура Закомментировать(Форма, ИмяРеквизита) Экспорт
	View(Форма, ИмяРеквизита).addComment();
КонецПроцедуры

Процедура УбратьКомментарии(Форма, ИмяРеквизита) Экспорт
	View(Форма, ИмяРеквизита).removeComment();
КонецПроцедуры

Процедура Форматировать(Форма, ИмяРеквизита) Экспорт
	View(Форма, ИмяРеквизита).editor.trigger("", "editor.action.formatDocument");
КонецПроцедуры

Процедура ДобавитьПереносСтроки(Форма, ИмяРеквизита) Экспорт
	View(Форма, ИмяРеквизита).addWordWrap();
КонецПроцедуры

Процедура УдалитьПереносСтроки(Форма, ИмяРеквизита) Экспорт
	View(Форма, ИмяРеквизита).removeWordWrap();
КонецПроцедуры

Функция ПолучитьФорматнуюСтроку(Форма, ИмяРеквизита) Экспорт
	Возврат View(Форма, ИмяРеквизита).getFormatString();
КонецФункции

Функция View(Форма, ИмяРеквизита)
	
	Если ПустаяСтрока(Форма[ИмяРеквизита]) Тогда
		Возврат Неопределено;
	КонецЕсли;
	ДокHTML = Форма.Элементы[ИмяРеквизита].Документ;
	Если ДокHTML = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат ДокHTML.defaultView;
	
КонецФункции

// Добавление универсальных процедур в исходники для работы с сохраненными в кэше JSON-нами.
// Добавляются updateMetadataObj(metadataJSON), updateMetadataModule(moduleJSON).
//
Процедура ДобавитьМетодыВИсходники(КаталогИсходников, ЭтоЛинуксКлиент)
	Если ЭтоЛинуксКлиент Тогда
		Возврат;
	КонецЕсли;
	
#Если НЕ ВебКлиент Тогда
	
	Попытка
		ЧтениеТекста = Новый ЧтениеТекста(КаталогИсходников + "editor.js", КодировкаТекста.UTF8);
		ТекущийТекстФайла = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();
		
		ПозРегиона = СтрНайти(ТекущийТекстФайла, "#region public API");
		Если ПозРегиона = 0 Тогда
			ВызватьИсключение "Не найден #region public API в editor.js";
		КонецЕсли;
		ПозРегиона = СтрНайти(ТекущийТекстФайла, "#endregion", , ПозРегиона);
		Если ПозРегиона = 0 Тогда
			ВызватьИсключение "Не найден #endregion public API в editor.js";
		КонецЕсли;
		
		ЗаписьТекста = Новый ЗаписьТекста(КаталогИсходников + "editor.js", "UTF-8");
		ЗаписьТекста.Записать(Лев(ТекущийТекстФайла, ПозРегиона + 10) +
		"
		|  updateMetadataObj = function (metadata) {
		|    let bsl = new bslHelper(editor.getModel(), editor.getPosition());
		|    return bsl.updateMetadataObj(metadata);
		|  }
		|  
		|  updateMetadataModule = function (moduleJSON) {
		|    return bslHelper.updateMetadataModule(moduleJSON);
		|  }"
		+ Сред(ТекущийТекстФайла, ПозРегиона + 10));
		ЗаписьТекста.Закрыть();
		
		ЧтениеТекста = Новый ЧтениеТекста(КаталогИсходников + "bsl_helper.js", КодировкаТекста.UTF8);
		ТекущийТекстФайла = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();
		
		// Текст вставляется перед "}" концом класса в конце файла
		ПозКонцаКласса = СтрНайти(ТекущийТекстФайла, "}", НаправлениеПоиска.СКонца);
		ТекущийТекстФайла = Лев(ТекущийТекстФайла, ПозКонцаКласса - 1) + 
		"	/**
		|	 * Updates bslMetadata from JSON-string which
		|	 * was received from 1C
		|	 * 
		|	 * @param {string} metadata JSON-string with metadata info
		|	 * 
		|	 * @returns {string} error message
		|	 */
		|	 updateMetadataObj(metadata) {
		|
		|		let parse = JSON.parse(metadata);
		|		try {
		|			if (!parse.count)
		|				return '';
		|			let path = parse.path;
		|			if (bslHelper.objectHasPropertiesFromArray(bslMetadata, path.split('.')))
		|				bslHelper.setObjectProperty(bslMetadata, path, parse.data);
		|			else
		|				throw new TypeError('Wrong path');
		|		}
		|		catch (e) {
		|			return e.message;
		|		}
		|		return '';
		|	}
		|
		|	/**
		|	 * Building bslMetadata structure for common and object methods
		|	 * 	 
		|	 * @param {string} moduleJSON a JSON data of module
		|	 * @param {string} path path to metadata-property
		|	 * 
		|	 * @returns {int} count of matches (export functions)
		|	 */
		|	 static updateMetadataModule(moduleJSON) {
		|		
		|		let parse = JSON.parse(moduleJSON);
		|		try {
		|			if (!parse.count)
		|				return '';
		|			let path = parse.path;
		|			if (path == 'globalfunctions') {
		|				for (const [key, value] of Object.entries(parse.module))
		|					bslGlobals.globalfunctions[key] = value;
		|			}
		|			else
		|			{
		|				let path_array = path.split('.');
		|				path_array.pop();
		|				
		|				if (bslHelper.objectHasPropertiesFromArray(bslMetadata, path_array))
		|					bslHelper.setObjectProperty(bslMetadata, path.split('.'), parse.module);
		|				else
		|					throw new TypeError('Wrong path');
		|			}
		|		}
		|		catch (e) {
		|			return e.message;
		|		}
		|		return '';
		|	}
		|"
		+ Сред(ТекущийТекстФайла, ПозКонцаКласса);
		
		ЗаписьТекста = Новый ЗаписьТекста(КаталогИсходников + "bsl_helper.js", КодировкаТекста.UTF8);
		ЗаписьТекста.Записать(ТекущийТекстФайла);
		ЗаписьТекста.Закрыть();
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю("Ошибка при модификации файлов bs_console: " + ОписаниеОшибки());
	КонецПопытки;
	
#КонецЕсли

КонецПроцедуры