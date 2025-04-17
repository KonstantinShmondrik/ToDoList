//
//  Texts.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import Foundation

enum Texts {

    enum AlertMessage {
        static let error = "Ошибка"
        static let cansel = "Отмена"
        static let OK = "Ok"
        static let yes = "Да"
        static let emptyIcons = "По вашему запросу ничего не найдено"
    }

    enum ErrorMessage {
        static let general = "Что-то пошло не так.\nПопробуйте позже, должно получиться"
        static let failLoading = "Данные не загрузились"
    }

    enum NetworkLayerErrorMessages {
        static let success = "Успешный запрос"
        static let redirect = "Необходимо перенаправить запрос"
        static let authenticationError = "Клиент не авторизован"
        static let clientError = "Некорректный запрос к серверу"
        static let serverError = "Ошибка сервера"
        static let outdated = "URL адрес устарел"
        static let requestFailed = "Ошибка выполнения сетевого запроса"
        static let noData = "Ответ сервера не содержит данных"
        static let unableToDecode = "Ошибка декодирования ответа сервера"
        static let badResponse = "Некорректный ответ сервера"
        static let tooManyRequests = "Слишком много запросов"
        static let accessDenied = "Доступ запрещен"
    }
}
