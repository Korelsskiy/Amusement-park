

Процедура ПеренестиНоменклатуруВТабличнуюЧасть() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПродажаБилета.Ссылка
	|ИЗ
	|	Документ.ПродажаБилета КАК ПродажаБилета
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПродажаБилета.ПозицииПродажи КАК ПродажаБилетаПозицииПродажи
	|		ПО ПродажаБилетаПозицииПродажи.Ссылка = ПродажаБилета.Ссылка
	|		И ПродажаБилетаПозицииПродажи.НомерСтроки = 1
	|ГДЕ
	|	ПродажаБилета.УдалитьНоменклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	И ПродажаБилетаПозицииПродажи.Ссылка ЕСТЬ NULL";
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДокОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Строка = ДокОбъект.ПозицииПродажи.Добавить();
		Строка.Номенклатура = ДокОбъект.УдалитьНоменклатура;
		Строка.Цена = ДокОбъект.УдалитьЦена;
		Строка.Количество = 1;
		Строка.Сумма = Строка.Цена;
		
		ДокОбъект.ОбменДанными.Загрузка = Истина;
		ДокОбъект.Записать();
		
	КонецЦикла;
КонецПроцедуры

Процедура Билет(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Билет)
	Макет = Документы.ПродажаБилета.ПолучитьМакет("Билет");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПродажаБилета.Номенклатура,
	|	ПродажаБилета.Номенклатура.КоличествоПосещений КАК КоличествоПосещений,
	|	ПродажаБилета.Дата,
	|	ПродажаБилета.ДокументСумма,
	|	ПродажаБилета.Номер
	|ИЗ
	|	Документ.ПродажаБилета КАК ПродажаБилета
	|ГДЕ
	|	ПродажаБилета.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ПараметрыОбласти = Новый Структура;
		ПараметрыОбласти.Вставить("Дата", Формат(Выборка.Дата, "ДЛФ=D;"));
		ПараметрыОБласти.Вставить("Номер", УдалитьЛидирующиеНули(Выборка.Номер));
		
		ОбластьЗаголовок.Параметры.Заполнить(ПараметрыОбласти);

		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры

Функция УдалитьЛидирующиеНули(Номер)
	Результат = Номер;
	Пока СтрНачинаетсяС(Результат, "0") Цикл
		Результат = Сред(Результат, 2);
	КонецЦикла;
	Возврат Результат;
КонецФункции
