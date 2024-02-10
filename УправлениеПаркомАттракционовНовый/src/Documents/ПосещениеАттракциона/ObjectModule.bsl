
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда



#Область ПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ,Режим)


	// регистр АктивныеПосещения
	Движения.АктивныеПосещения.Записывать = Истина;
	Движение = Движения.АктивныеПосещения.Добавить();
	Движение.Период = Дата;
	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	Движение.Основание = Основание;
	Движение.Аттракцион = Аттракцион;
	Движение.КоличествоПосещений = 1;
	
	Движения.Записать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		|	АктивныеПосещенияОстатки.Основание
		|ИЗ
		|	РегистрНакопления.АктивныеПосещения.Остатки(, Основание = &Основание) КАК АктивныеПосещенияОстатки
		|ГДЕ
		|	АктивныеПосещенияОстатки.КоличествоПосещенийОстаток < 0";
		
	Запрос.УстановитьПараметр("Основание", Основание);
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "По одному билету можно проходить только один раз.";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "Основание";
		Сообщение.Сообщить();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Код процедур и функций

#КонецОбласти

#Область Инициализация

#КонецОбласти

#КонецЕсли
